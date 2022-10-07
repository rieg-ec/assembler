module Assembler
  class Instruction
    MNEMONICS = %w[MOV ADD SUB AND OR XOR NOT SHL SHR INC DEC CMP PUSH POP CALL RET NOP].freeze
    JMP_MNEMONICS = %w[JMP JEQ JNE JGT JGE JLT JLE JCR].freeze
    ALLOWED_MNEMONICS = MNEMONICS + JMP_MNEMONICS

    attr_reader :mnemonic, :first_operand, :second_operand

    def initialize(mnemonic, first_operand = nil, second_operand = nil)
      unless ALLOWED_MNEMONICS.include?(mnemonic)
        raise InvalidMnemonicError(
          "#{mnemonic} #{first_operand} #{second_operand}"
        )
      end

      raise InvalidOperandError("#{first_operand}") if first_operand && !valid_operand?(first_operand)
      raise InvalidOperandError("#{second_operand}") if second_operand && !valid_operand?(second_operand)

      @mnemonic = mnemonic
      @_first_operand = first_operand
      @_second_operand = second_operand
      @first_operand = operand_to_integer(first_operand)
      @second_operand = operand_to_integer(second_operand)
    end

    def replace_labels(labels)
      if JMP_MNEMONICS.include?(@mnemonic)
        @first_operand = labels[@_first_operand]
        @_first_operand = @first_operand
      end
    end

    def to_s
      "#{mnemonic} #{first_operand} #{second_operand}"
    end

    def to_opcode
      literal = begin
        if second_operand_literal?
          second_operand
        elsif first_operand_ram_address?
          @first_operand
        elsif second_operand_ram_address?
          @second_operand
        else
          0
        end
      end.to_s(2)
      literal = literal.rjust(16, "0")
      "#{literal}#{selA}#{selB}#{enableA}#{enableB}#{selALU}#{w}#{jmp}000000"
    end

    def first_operand_A?
      A?(@_first_operand)
    end

    def first_operand_B?
      B?(@_first_operand)
    end

    def first_operand_ram_address?
      ram_address?(@_first_operand)
    end

    def second_operand_A?
      A?(@_second_operand)
    end

    def second_operand_B?
      B?(@_second_operand)
    end

    def second_operand_ram_address?
      ram_address?(@_second_operand)
    end

    def second_operand_literal?
      lit?(@_second_operand)
    end

    def A?(operand)
      return false if operand.nil?

      operand == "A"
    end

    def B?(operand)
      return false if operand.nil?

      operand == "B"
    end

    def ram_address?(operand)
      return false if operand.nil? || !operand.start_with?("(") || !operand.end_with?(")")

      operand = operand[1..-2]
      lit?(operand)
    end

    def lit?(operand)
      return false if operand.nil?

      if operand.end_with?("d") || operand.end_with?("b")
        operand = operand[0..-2]
      elsif operand.end_with?("h")
        operand = operand[0..-2].to_i(16)
      end

      !!Integer(operand, exception: false)
    end

    private

    def valid_operand?(operand)
      A?(operand) || B?(operand) || ram_address?(operand) || lit?(operand)
    end

    def operand_to_integer(operand)
      return operand if operand.nil? || A?(operand) || B?(operand)

      operand = operand[1..-2] if ram_address?(operand)

      if operand.end_with?("b")
        operand.gsub("b", "").to_i(2)
      elsif operand.end_with?("h")
        operand.gsub("h", "").to_i(16)
      elsif operand.end_with?("d")
        operand.gsub("d", "").to_i(10)
      else
        operand.to_i(10)
      end
    end

    def selA
      if inc? && !first_operand_A?
        "01"
      elsif second_operand_A? ||
            add? || sub? || and? || or? || xor? ||
            not? || shl? || shr? || cmp? ||
            (inc? && first_operand_A?) ||
            (dec? && first_operand_A?)
        "10"
      else
        "00"
      end
    end

    def selB
      if second_operand_literal?
        "01"
      elsif second_operand_B? || (inc? && first_operand_B?) ||
            ((add? || sub? || and? || or? || xor?) && (first_operand_ram_address? || (first_operand_B? && second_operand_A?)))
        "10"
      elsif second_operand_ram_address? || (inc? && first_operand_ram_address?) ||
            add? || sub? || and? || or? || xor? ||
            not? || shl? || shr? || cmp? ||
            (inc? && first_operand_B?) ||
            (dec? && first_operand_B?)
        "11"
      else
        "00"
      end
    end

    def enableA
      if !cmp? && first_operand_A?
        "1"
      else
        "0"
      end
    end

    def enableB
      if first_operand_B?
        "1"
      else
        "0"
      end
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
      if first_operand_ram_address?
        "1"
      else
        "0"
      end
    end

    def jmp
      if jmp?
        "1000"
      elsif jeq?
        "1001"
      elsif jne?
        "1010"
      elsif jgt?
        "1011"
      elsif jge?
        "1100"
      elsif jlt?
        "1101"
      elsif jle?
        "1110"
      elsif jcr?
        "1111"
      else
        "0000"
      end
    end

    def mov?
      @mnemonic == "MOV"
    end

    def add?
      @mnemonic == "ADD"
    end

    def sub?
      @mnemonic == "SUB"
    end

    def and?
      @mnemonic == "AND"
    end

    def or?
      @mnemonic == "OR"
    end

    def xor?
      @mnemonic == "XOR"
    end

    def not?
      @mnemonic == "NOT"
    end

    def shl?
      @mnemonic == "SHL"
    end

    def shr?
      @mnemonic == "SHR"
    end

    def inc?
      @mnemonic == "INC"
    end

    def dec?
      @mnemonic == "DEC"
    end

    def cmp?
      @mnemonic == "CMP"
    end

    def push?
      @mnemonic == "PUSH"
    end

    def pop?
      @mnemonic == "POP"
    end

    def call?
      @mnemonic == "CALL"
    end

    def ret?
      @mnemonic == "RET"
    end

    def nop?
      @mnemonic == "NOP"
    end

    def jmp?
      @mnemonic == "JMP"
    end

    def jeq?
      @mnemonic == "JEQ"
    end

    def jne?
      @mnemonic == "JNE"
    end

    def jgt?
      @mnemonic == "JGT"
    end

    def jge?
      @mnemonic == "JGE"
    end

    def jlt?
      @mnemonic == "JLT"
    end

    def jle?
      @mnemonic == "JLE"
    end

    def jcr?
      @mnemonic == "JCR"
    end
  end
end
