require "forwardable"

module Assembler
  class Operand
    extend Forwardable

    def_delegators :@operand, :to_s, :nil?

    def initialize(operand)
      @operand = operand
    end

    def to_i
      return 0 if ["A", "B", "(B)"].include?(@operand)

      operand = @operand
      operand = operand[1..-2] if ram_address?

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

    def ram_address?
      return false if @operand.nil?

      @operand.start_with?("(") && @operand.end_with?(")")
    end

    def literal?
      return false if @operand.nil?

      operand = @operand
      if operand.end_with?("d") || operand.end_with?("b")
        operand = operand[0..-2]
      elsif operand.end_with?("h")
        operand = operand[0..-2].to_i(16)
      end

      !!Integer(operand, exception: false)
    end

    def literal_ram_addres?
      ram_address? && !indirect_B?
    end

    def A?
      return false if @operand.nil?

      @operand == "A"
    end

    def B?
      return false if @operand.nil?

      @operand == "B"
    end

    def indirect_B?
      return false if @operand.nil?

      @operand == "(B)"
    end

    def valid?
      @operand.nil? || A? || B? || ram_address? || literal? || indirect_B?
    end

    def replace_labels(labels)
      @operand = labels[@operand] if labels.key?(@operand)
    end
  end
end
