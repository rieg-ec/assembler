# frozen_string_literal: true

require "assembler/assembler"

RSpec.describe Assembler::Assembler do
  describe "#assemble" do
    [2].each do |i|
      it "assembles the #{i}th example" do
        fixture = fixture("test#{i}.asm").read
        assembler = described_class.new(fixture)
        assembler.parse!
        opcodes = assembler.assemble
        expect(opcodes).to eq(fixture("test#{i}.opcode").read.strip)
      end
    end
  end
end
