module Helpers
  module Mnemonics
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

    def push?
      @mnemonic == "PUSH"
    end

    def pop?
      @mnemonic == "POP"
    end

    def ret?
      @mnemonic == "RET"
    end

    def call?
      @mnemonic == "CALL"
    end
  end
end
