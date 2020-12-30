require_relative 'board.rb'

board = Board.new(4, required_answers: 2)
board.solve
