require_relative "assembler"
require_relative "instruction"

module Assembler
  class Assembler
    INCREMENT_SP = ("0" * 16 + "00000000000000001000").freeze
    COMMENT_SYMBOL = "/".freeze

    attr_reader :instructions, :labels, :variables

    def initialize(assembly)
      @assembly = assembly
      @instructions = []
      @labels = {}
      @variables = {}
      @ram_index = 0
    end

    def parse!
      data_section, code_section = split_and_clean_sections(@assembly)
      parse_data_section(data_section)
      parse_code_section(code_section)
    end

    def assemble
      instructions = @instructions.map do |instruction|
        next(instruction) if instruction.is_a?(String)

        instruction = Instruction.new(*instruction)
        instruction.replace_labels(@labels)
        instruction.to_opcode
      end

      instructions.join("\n")
    end

    private

    def split_and_clean_sections(data)
      data_section = data.split("CODE").first
                         .split("\n")
                         .drop(1)
                         .map { |line| line.split(COMMENT_SYMBOL).first&.strip }
                         .reject { |line| line.nil? || line.strip.empty? }
      code_section = data.split("CODE").last
                         .split("\n")
                         .drop(1)
                         .map { |line| line.split(COMMENT_SYMBOL).first&.strip }
                         .reject { |line| line.nil? || line.strip.empty? }
      [data_section, code_section]
    end

    def parse_data_section(data_section)
      data_section.each do |line|
        raise "Invalid data section" if line.split(" ").length != 2

        name, value = line.split(" ")
        @variables[name] = value
        @instructions << ["MOV", "A", value]
        @instructions << ["MOV", "(#{@ram_index})", "A"]
        @ram_index += 1
      end
    end

    def parse_code_section(code_section)
      code_section.each do |line|
        if line.include?(":")
          label = line.split(":").first
          @labels[label] = @instructions.length.to_s
          # @TODO there may be issues when a label is the last line of the code section
          next
        end

        mnemonic, first_operand, second_operand = line.gsub(",", " ").split(" ").map(&:strip)
        first_operand = replace_variable_with_value(first_operand)
        second_operand = replace_variable_with_value(second_operand)
        @instructions << INCREMENT_SP if %w[POP RET].include?(mnemonic)
        @instructions << [mnemonic, first_operand, second_operand]
      end
    end

    def replace_variable_with_value(operand)
      if @variables.key?(operand)
        @variables[operand]
      else
        operand
      end
    end
  end
end
