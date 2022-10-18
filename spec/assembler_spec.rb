# frozen_string_literal: true

require "assembler/assembler"

RSpec.describe Assembler::Assembler do
  describe "#assemble" do
    it "produces right opcodes" do
      fixture = fixture("test1.asm").read
      assembler = described_class.new(fixture)
      assembler.parse!
      opcodes = assembler.assemble
      expect(opcodes).to eq(fixture("test1.opcode").read.strip)
    end
  end
end
