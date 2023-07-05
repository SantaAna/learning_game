defmodule Games.TicTacToe.ComputerPlayer do
  alias Games.TicTacToe.Board

  def move(board, type \\ :random) do
    case type do
      :random -> random_move(board)
      :perfect -> elem(perfect_move(board), 0)
    end
  end

  def random_move(board) do
    Board.free_spaces(board)
    |> Enum.random()
    |> elem(0)
  end

  def perfect_move(board, turn \\ :o) do
    free_spaces = Board.free_spaces(board) |> Enum.unzip() |> elem(0)

    case [free_spaces, turn, Games.TicTacToe.winner(board)] do
      [[], _, :no_winner] ->
        {nil, 0}

      [_, _, {true, :o}] ->
        {nil, 1}

      [_, _, {true, :x}] ->
        {nil, -1}

      [possible_moves, :o, _] ->
        Enum.map(possible_moves, fn move ->
          {:ok, board} = Board.mark(board, move, :o)
          {move, board}
        end)
        |> Enum.map(fn {move, board} -> {move, elem(perfect_move(board, :x), 1)} end)
        |> Enum.max_by(fn {_move, score} -> score end)

      [possible_moves, :x, _] ->
        Enum.map(possible_moves, fn move ->
          {:ok, board} = Board.mark(board, move, :x)
          {move, board}
        end)
        |> Enum.map(fn {move, board} -> {move, elem(perfect_move(board, :o), 1)} end)
        |> Enum.min_by(fn {_move, score} -> score end)
    end
  end
end
