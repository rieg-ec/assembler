require_relative "./lib/assembler"

if ARGV.length != 1
  puts "Usage: ruby assembler.rb <file.asm>"
  exit
end

assembler = Assembler::Assembler.new(ARGV[0])
assembler.parse!

opcodes = assembler.assemble

puts opcodes
