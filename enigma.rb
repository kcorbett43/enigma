class Rotor
  attr_accessor :arr
  def initialize(rotor,position)
    @arr = rotor.split("")
    @turns = 0
    @offset = 0
    @position = position
  end

  def update_offset
    if update_offset?
      first = @arr.shift
      @arr.push(first)
      @offset += 1
    end
  end

  def update_offset?
    return false if @position == "reflector"

    if @position == 0
      return true
    elsif @offset < 26^@position
      return false
    elsif ( @turns + 26^@position) % ( 26^@position ) == 0
      return true
    else
      return false
    end
  end
end

class RotorSystem
  attr_accessor :rotors, :encrypted_message
  def initialize(*rotors, reflector, plug_board)
    @rotors = []
    rotor_pos = 0
    rotors.each { |rotor| 
      rotor = Rotor.new(rotor,rotor_pos)
      @rotors << rotor
      rotor_pos += 1
    }
    @alpha_array = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")
    @reflector = Rotor.new(reflector, "reflector")
    @encrypted_message = ""
    @plug_board = plug_board.map{ |arr| arr.map( &:upcase ) }   
  end

  def encrypt(message)
    rotor_encrypt(message)
  end

  def rotor_encrypt(message)
    letters = message.split("")
    letters.each{ |letter| 
      letter = swap(letter)
      @rotors.each { |rotor|
        rotor.update_offset
        letter_pos = @alpha_array.find_index(letter)
        letter = rotor.arr[letter_pos]
      }

      letter = reflect(letter)

      @rotors.reverse.each { |rotor|
        letter_pos = rotor.arr.find_index(letter)
        letter = @alpha_array[letter_pos]
      }
      letter = swap(letter)

      @encrypted_message += letter
    }
  end

  def swap(letter)
    @plug_board.each { |swapped|
      if letter == swapped[0]
        return swapped[1].to_s
      end

      if letter == swapped[1]
        return swapped[0].to_s
      end
    }
    return letter
  end

  def reflect(letter)
    letter_pos = @alpha_array.find_index(letter)
    letter = @reflector.arr[letter_pos]
  end
end


std_str      = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
              #"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
rotor_I_str  = "DMTWSILRUYQNKFEJCAZBPGXOHV"
              #"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
rotor_II_str = "JGDQOXUSCAMIFRVTPNEWKBLZYH"
              #"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
reflector_a  = "EJMZALYXVBWFCRQUONTSPIKHGD"

plug_board = [["a","b"],["c","d"]]
rotor_sys = RotorSystem.new(rotor_I_str, rotor_II_str, reflector_a, plug_board)


message = gets.chomp.upcase
rotor_sys.encrypt(message)
message = rotor_sys.encrypted_message
p message

p rotor_I_str
d_rotor_sys = RotorSystem.new(rotor_I_str, rotor_II_str, reflector_a, plug_board)
d_message = gets.chomp.upcase
d_rotor_sys.encrypt(d_message)
d_message = d_rotor_sys.encrypted_message
p d_message
