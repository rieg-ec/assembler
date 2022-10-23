require_relative "../helpers/mnemonics"
require_relative "./operand"

module Assembler
  class Instruction
    include Helpers::Mnemonics

    MNEMONICS = %w[MOV ADD SUB AND OR XOR NOT SHL SHR INC DEC CMP PUSH POP CALL RET NOP].freeze
    JMP_MNEMONICS = %w[JMP JEQ JNE JGT JGE JLT JLE JCR].freeze
    ALLOWED_MNEMONICS = MNEMONICS + JMP_MNEMONICS

    def initialize(mnemonic, first_operand = nil, second_operand = nil)
      unless ALLOWED_MNEMONICS.include?(mnemonic)
        raise InvalidMnemonicError(
          "#{mnemonic} #{first_operand} #{second_operand}"
        )
      end

      @mnemonic = mnemonic
      @first_operand = Operand.new(first_operand)
      @second_operand = Operand.new(second_operand)
      @_first_operand = first_operand
      @_second_operand = second_operand
    end

    def replace_labels(labels)
      @first_operand.replace_labels(labels) if call? || jmp || jeq? || jne? || jgt? || jge? || jlt? || jle? || jcr?
    end

    def to_s
      if !@second_operand.nil?
        "#{@mnemonic} #{@first_operand}, #{@second_operand}"
      elsif !@first_operand.nil?
        "#{@mnemonic} #{@first_operand}"
      else
        @mnemonic
      end
    end

    def to_opcode
      literal = begin
        if (inc? || dec?) && @first_operand.A?
          1
        elsif @first_operand.literal? || @first_operand.literal_ram_addres?
          @first_operand
        elsif @second_operand.literal? || @second_operand.literal_ram_addres?
          @second_operand
        else
          0
        end
      end.to_i.to_s(2).rjust(16, "0")

      "#{literal}#{selA}#{selB}#{enableA}#{enableB}#{selALU}#{w}#{loadPC}#{jmp}#{selAdd}#{incSP}#{decSP}#{selPC}#{selDin}"
    end

    private

    def selA
      if inc? && !@first_operand.A?
        "01"
      elsif @second_operand.A? ||
            add? || sub? || and? || or? || xor? ||
            not? || shl? || shr? || cmp? ||
            (inc? && @first_operand.A?) ||
            (dec? && @first_operand.A?) ||
            (push? && @first_operand.A?)
        "10"
      else
        "00"
      end
    end

    def selB
      if @second_operand.literal? ||
         (inc? && @first_operand.A?) ||
         (dec? && @first_operand.A?) ||
         (cmp? && @second_operand.literal?)
        "01"
      elsif @second_operand.B? || ((inc? || push?) && @first_operand.B?) ||
            ((add? || sub? || and? || or? || xor?) && (@first_operand.ram_address? || (@first_operand.B? && @second_operand.A?)))
        "10"
      elsif @second_operand.ram_address? ||
            (inc? && @first_operand.ram_address?) ||
            ((add? || sub? || and? || or? || xor?) && @second_operand.ram_address?) ||
            cmp? ||
            (inc? && @first_operand.indirect_B?) ||
            (push? && @first_operand.B?)
        "11"
      else
        "00"
      end
    end

    def enableA
      !cmp? && @first_operand.A? && !push? ? "1" : "0"
    end

    def enableB
      @first_operand.B? && !push? ? "1" : "0"
    end

    def selALU
      if sub? || cmp? || dec?
        "001"
      elsif and?
        "010"
      elsif or?
        "011"
      elsif xor?
        "100"
      elsif not?
        "101"
      elsif shr?
        "110"
      elsif shl?
        "111"
      else
        "000"
      end
    end

    def w
      @first_operand.ram_address? || push? || call? ? "1" : "0"
    end

    def loadPC
      if jmp? || jeq? || jne? || jgt? || jge? || jlt? || jle? || jcr? || call? || ret?
        "1"
      else
        "0"
      end
    end

    def selAdd
      if @first_operand.indirect_B? || @second_operand.indirect_B?
        "01"
      elsif push? || pop? || ret? || call?
        "10"
      else
        "00"
      end
    end

    def incSP
      "0"
    end

    def decSP
      if push? || call?
        "1"
      else
        "0"
      end
    end

    def selPC
      ret? ? "1" : "0"
    end

    def selDin
      call? ? "1" : "0"
    end

    def jmp
      if jmp?
        "000"
      elsif jeq?
        "001"
      elsif jne?
        "010"
      elsif jgt?
        "011"
      elsif jge?
        "100"
      elsif jlt?
        "101"
      elsif jle?
        "110"
      elsif jcr?
        "111"
      else
        "000"
      end
    end
  end
end
