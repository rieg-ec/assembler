# frozen_string_literal: true

require_relative "assembler/version"
require_relative "assembler/assembler"

module Assembler
  class AssemblerError < StandardError; end
  class InvalidMnemonicError < AssemblerError; end
end
