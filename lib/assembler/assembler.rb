require_relative "assembler"
require_relative "instruction"

module Assembler
  class Assembler
    attr_reader :instructions

    def initialize(filename)
      @filename = filename
      @instructions = []
      @labels = {}
      @variables = {}
      @ram_index = 0
    end

    def parse!
      data = File.read(@filename)
      data_section, code_section = split_and_clean_sections(data)
      parse_data_section!(data_section)
      parse_code_section!(code_section)
    end

    def assemble
      instructions = @instructions.map do |instruction|
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
                         .map { |line| line.split("#").first.strip }
                         .reject { |line| line.strip.empty? }
                         .drop(1)
      code_section = data.split("CODE").last
                         .split("\n")
                         .map { |line| line.split("#").first.strip }
                         .reject { |line| line.strip.empty? }
                         .drop(1)
      [data_section, code_section]
    end

    def parse_data_section!(data_section)
      data_section.each do |line|
        raise "Invalid data section" if line.split(" ").length != 2

        name, value = line.split(" ")
        @variables[name] = value
        @instructions << ["MOV", "(#{@ram_index})", value]
        @ram_index += 1
      end
    end

    def parse_code_section!(code_section)
      code_section.each do |line|
        if line.include?(":")
          label = line.split(":").first
          @labels[label] = @instructions.length
          # @TODO there may be issues when a label is the last line of the code section
          next
        end

        mnemonic, first_operand, second_operand = line.gsub(",", " ").split(" ").map(&:strip)
        first_operand = replace_variable_with_value(first_operand)
        second_operand = replace_variable_with_value(second_operand)
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
