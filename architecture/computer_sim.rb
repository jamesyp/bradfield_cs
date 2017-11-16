def computer(reg, mem)
  while true
    pc = reg[0]
    inst, arg_0, arg_1 = mem[pc..pc+2]

    case inst
    when 0x00      # NO-OP
    when 0x01      # LOAD
      reg[arg_0] = mem[arg_1] + 256 * mem[arg_1 + 1]
    when 0x02      # STORE
      mem[arg_1]     = reg[arg_0] % 256
      mem[arg_1 + 1] = reg[arg_0] / 256
    when 0x03      # ADD
      reg[arg_0] += reg[arg_1]
    when 0x04      # SUB
      reg[arg_0] -= reg[arg_1]
    when 0x10      # JMP
      reg[0] = arg_0
      next
    when 0x11      # JMP0
      if reg[arg_0] == 0
        reg[0] = arg_1
        next
      end
    when 0xFF      # HALT
      break
    end

    reg[0] += 0x03
  end
end

reg = Array.new(4, 0)
mem = [
  # Initial LOAD
  0x01,0x01,0x3C,
  0x01,0x02,0x3E,
  0x01,0x03,0x35,

  # Input B becomes loop counter, decrement and test
  0x04,0x02,0x03,
  0x11,0x02,0x1E,

  # If not zero, store counter,
  # then load input A & add to running total in reg 1
  0x02,0x02,0x33,
  0x01,0x02,0x3C,
  0x03,0x01,0x02,

  # Load loop counter then jump back
  0x01,0x02,0x33,
  0x10,0x09,0x00,

  # Otherwise, store result in output and HALT
  0x02,0x01,0x3A,
  0xFF
]
# Program data
mem[0x35] = 0x01
mem[0x36] = 0x00

# Input
mem[0x3C] = 0x05
mem[0x3D] = 0x00
mem[0x3E] = 0x06
mem[0x3F] = 0x00

computer(reg, mem)

puts "A: #{mem[0x3C..0x3D]}"
puts "B: #{mem[0x3E..0x3F]}"
puts "O: #{mem[0x3A..0x3B]}"
