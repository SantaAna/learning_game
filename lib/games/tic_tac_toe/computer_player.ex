defmodule Games.TicTacToe.ComputerPlayer do
  alias Games.TicTacToe.Board
  def move(board, type \\ :random) do 
    case type do
      :random -> random_move(board)
    end
  end

  def random_move(board) do
    Board.free_spaces(board) 
    |> Enum.random()
    |> elem(0)
  end
end
