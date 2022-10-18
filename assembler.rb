require_relative "./lib/assembler"

if ARGV.length != 1
  puts "Usage: ruby assembler.rb <file.asm>"
  exit
end

assembly = File.read(ARGV[0])
assembler = Assembler::Assembler.new(assembly)
assembler.parse!

opcodes = assembler.assemble

puts opcodes
