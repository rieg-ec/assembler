#!/usr/bin/env ruby

require_relative "./lib/assembler"

if ARGV.length != 2
  puts "Usage: ruby assembler.rb <file.asm> <file.opcode>"
  exit
end

assembly = File.read(ARGV[0])
assembler = Assembler::Assembler.new(assembly)
assembler.parse!

opcodes = assembler.assemble

File.open(ARGV[1], "w") do |f|
  f.write(opcodes)
end
