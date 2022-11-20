# frozen_string_literal: true

require "assembler/instruction"

RSpec.describe Assembler::Instruction do
  describe "#to_opcode" do
    it "MOV A, B" do
      instruction = described_class.new("MOV", "A", "B")
      expect(instruction.to_opcode).to eq(
        "0" * 16 + "00101000000000000000"
      )
    end

    it "MOV B, A" do
      instruction = described_class.new("MOV", "B", "A")
      expect(instruction.to_opcode).to eq(
        "0" * 16 + "10000100000000000000"
      )
    end

    it "MOV A, Literal" do
      instruction = described_class.new("MOV", "A", "1")
      expect(instruction.to_opcode).to eq(
        "0" * 15 + "1" + "00011000000000000000"
      )
    end

    it "MOV B, Literal" do
      instruction = described_class.new("MOV", "B", "FFh")
      expect(instruction.to_opcode).to eq(
        "0" * 8 + "1" * 8 + "00010100000000000000"
      )
    end

    it "MOV A, (Dir)" do
      instruction = described_class.new("MOV", "A", "(010b)")
      expect(instruction.to_opcode).to eq(
        "0" * 14 + "10" + "00111000000000000000"
      )
    end

    it "MOV B, (Dir)" do
      instruction = described_class.new("MOV", "B", "(4d)")
      expect(instruction.to_opcode).to eq(
        "0" * 13 + "100" + "00110100000000000000"
      )
    end

    it "MOV (Dir), A" do
      instruction = described_class.new("MOV", "(010b)", "A")
      expect(instruction.to_opcode).to eq(
        "0" * 14 + "10" + "10000000010000000000"
      )
    end

    it "MOV (Dir), B" do
      instruction = described_class.new("MOV", "(4d)", "B")
      expect(instruction.to_opcode).to eq(
        "0" * 13 + "100" + "00100000010000000000"
      )
    end

    it "MOV A, (B)" do
      instruction = described_class.new("MOV", "A", "(B)")
      expect(instruction.to_opcode).to eq(
        "0" * 16 + "00111000000000010000"
      )
    end

    it "MOV B, (B)" do
      instruction = described_class.new("MOV", "B", "(B)")
      expect(instruction.to_opcode).to eq(
        "0" * 16 + "00110100000000010000"
      )
    end

    it "MOV (B), A" do
      instruction = described_class.new("MOV", "(B)", "A")
      expect(instruction.to_opcode).to eq(
        "0" * 16 + "10000000010000010000"
      )
    end

    it "MOV (B), Lit" do
      instruction = described_class.new("MOV", "(B)", "1")
      expect(instruction.to_opcode).to eq(
        "0" * 15 + "1" + "00010000010000010000"
      )
    end

    it "ADD A, B" do
      instruction = described_class.new("ADD", "A", "B")
      expect(instruction.to_opcode).to eq(
        "0" * 16 + "10101000000000000000"
      )
    end

    it "SUB B, A" do
      instruction = described_class.new("SUB", "B", "A")
      expect(instruction.to_opcode).to eq(
        "0" * 16 + "10100100100000000000"
      )
    end

    it "AND A, Lit" do
      instruction = described_class.new("AND", "A", "Ah")
      expect(instruction.to_opcode).to eq(
        "0" * 12 + "1010" + "10011001000000000000"
      )
    end

    it "OR B, Lit" do
      instruction = described_class.new("OR", "B", "1")
      expect(instruction.to_opcode).to eq(
        "0" * 15 + "1" + "10010101100000000000"
      )
    end

    it "XOR A, (Dir)" do
      instruction = described_class.new("XOR", "A", "(1)")
      expect(instruction.to_opcode).to eq(
        "0" * 15 + "1" + "10111010000000000000"
      )
    end

    it "ADD B, (Dir)" do
      instruction = described_class.new("ADD", "B", "(1)")
      expect(instruction.to_opcode).to eq(
        "0" * 15 + "1" + "10110100000000000000"
      )
    end

    it "ADD (Dir)" do
      instruction = described_class.new("ADD", "(Dir)")
      expect(instruction.to_opcode).to eq(
        "0" * 16 + "10100000010000000000"
      )
    end

    it "ADD A, (B)" do
      instruction = described_class.new("ADD", "A", "(B)")
      expect(instruction.to_opcode).to eq(
        "0" * 16 + "10111000000000010000"
      )
    end

    it "ADD B, (B)" do
      instruction = described_class.new("ADD", "B", "(B)")
      expect(instruction.to_opcode).to eq(
        "0" * 16 + "10110100000000010000"
      )
    end

    it "NOT A" do
      instruction = described_class.new("NOT", "A")
      expect(instruction.to_opcode).to eq(
        "0" * 16 + "10001010100000000000"
      )
    end

    it "SHR B, A" do
      instruction = described_class.new("SHR", "B", "A")
      expect(instruction.to_opcode).to eq(
        "0" * 16 + "10000111000000000000"
      )
    end

    it "SHL (Dir), A" do
      instruction = described_class.new("SHL", "(2)", "A")
      expect(instruction.to_opcode).to eq(
        "0" * 14 + "10" + "10000011110000000000"
      )
    end

    it "NOT (B), A" do
      instruction = described_class.new("NOT", "(B)", "A")
      expect(instruction.to_opcode).to eq(
        "0" * 16 + "10000010110000010000"
      )
    end

    it "INC A" do
      instruction = described_class.new("INC", "A")
      expect(instruction.to_opcode).to eq(
        "0" * 15 + "1" + "10011000000000000000"
      )
    end

    it "INC B" do
      instruction = described_class.new("INC", "B")
      expect(instruction.to_opcode).to eq(
        "0" * 16 + "01100100000000000000"
      )
    end

    it "INC (B)" do
      instruction = described_class.new("INC", "(B)")
      expect(instruction.to_opcode).to eq(
        "0" * 16 + "01110000010000010000"
      )
    end

    it "INC (Dir)" do
      instruction = described_class.new("INC", "(1)")
      expect(instruction.to_opcode).to eq(
        "0" * 15 + "1" + "01110000010000000000"
      )
    end

    it "DEC A" do
      instruction = described_class.new("DEC", "A")
      expect(instruction.to_opcode).to eq(
        "0" * 15 + "1" + "10011000100000000000"
      )
    end

    it "CMP A, B" do
      instruction = described_class.new("CMP", "A", "B")
      expect(instruction.to_opcode).to eq(
        "0" * 16 + "10100000100000000000"
      )
    end

    it "CMP A, Lit" do
      instruction = described_class.new("CMP", "A", "1")
      expect(instruction.to_opcode).to eq(
        "0" * 15 + "1" + "10010000100000000000"
      )
    end

    it "CMP A, (Dir)" do
      instruction = described_class.new("CMP", "A", "(1)")
      expect(instruction.to_opcode).to eq(
        "0" * 15 + "1" + "10110000100000000000"
      )
    end

    it "NOP" do
      instruction = described_class.new("NOP")
      expect(instruction.to_opcode).to eq(
        "0" * 16 + "00000000000000000000"
      )
    end

    it "JMP 1" do
      instruction = described_class.new("JMP", "1")
      expect(instruction.to_opcode).to eq(
        "0" * 15 + "1" + "00000000001000000000"
      )
    end

    it "JEQ 1" do
      instruction = described_class.new("JEQ", "1")
      expect(instruction.to_opcode).to eq(
        "0" * 15 + "1" + "00000000001001000000"
      )
    end

    it "JNE 1" do
      instruction = described_class.new("JNE", "1")
      expect(instruction.to_opcode).to eq(
        "0" * 15 + "1" + "00000000001010000000"
      )
    end

    it "JGT 1" do
      instruction = described_class.new("JGT", "1")
      expect(instruction.to_opcode).to eq(
        "0" * 15 + "1" + "00000000001011000000"
      )
    end

    it "JGE 1" do
      instruction = described_class.new("JGE", "1")
      expect(instruction.to_opcode).to eq(
        "0" * 15 + "1" + "00000000001100000000"
      )
    end

    it "JLT 1" do
      instruction = described_class.new("JLT", "1")
      expect(instruction.to_opcode).to eq(
        "0" * 15 + "1" + "00000000001101000000"
      )
    end

    it "JLE 1" do
      instruction = described_class.new("JLE", "1")
      expect(instruction.to_opcode).to eq(
        "0" * 15 + "1" + "00000000001110000000"
      )
    end

    it "JCR 1" do
      instruction = described_class.new("JCR", "1")
      expect(instruction.to_opcode).to eq(
        "0" * 15 + "1" + "00000000001111000000"
      )
    end

    it "PUSH A" do
      instruction = described_class.new("PUSH", "A")
      expect(instruction.to_opcode).to eq(
        "0" * 16 + "10000000010000100100"
      )
    end

    it "PUSH B" do
      instruction = described_class.new("PUSH", "B")
      expect(instruction.to_opcode).to eq(
        "0" * 16 + "00100000010000100100"
      )
    end

    it "POP A" do
      instruction = described_class.new("POP", "A")
      expect(instruction.to_opcode).to eq(
        "0" * 16 + "00111000000000100000"
      )
    end

    it "POP B" do
      instruction = described_class.new("POP", "B")
      expect(instruction.to_opcode).to eq(
        "0" * 16 + "00110100000000100000"
      )
    end

    it "RET" do
      instruction = described_class.new("RET")
      expect(instruction.to_opcode).to eq(
        "0" * 16 + "00000000001000100010"
      )
    end

    it "CALL 1" do
      instruction = described_class.new("CALL", "1")
      expect(instruction.to_opcode).to eq(
        "0" * 15 + "1" + "00000000011000100101"
      )
    end
  end
end
