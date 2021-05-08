# frozen_string_literal: true

# Responsible for converting chess notation and coordinates
class ChessNotation
  def convert_move_to_coord(move)
    correct_numbers = convert_move_to_correct_numbers(move)
    string_to_coord(correct_numbers)
  end

  def convert_move_to_correct_numbers(move)
    y_number = letter_to_number(move[0])
    x_number = number_to_number(move[1])
    x_number + y_number
  end

  def letter_to_number(letter)
    hash = { '0' => 'a', '1' => 'b', '2' => 'c', '3' => 'd', '4' => 'e', '5' => 'f', '6' => 'g', '7' => 'h' }
    hash.key(letter)
  end

  def number_to_number(number)
    conversion = number.to_i - 1
    conversion.to_s
  end

  def string_to_coord(string)
    string.chomp.split('').map(&:to_i)
  end

  def coords_to_chess_notation(array)
    chess_notation_array = []

    array.map do |move|
      chess_notation_array.push(notate(move))
    end
    chess_notation_array
  end

  def notate(move)
    letter = y_coord_to_letter(move[1])
    number = x_coord_to_number(move[0])
    letter + number
  end

  def y_coord_to_letter(num)
    hash = { 'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3, 'e' => 4, 'f' => 5, 'g' => 6, 'h' => 7 }
    hash.key(num)
  end

  def x_coord_to_number(num)
    notation_number = num + 1
    notation_number.to_s
  end
end
