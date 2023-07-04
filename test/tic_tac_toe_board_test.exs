defmodule TicTacToeBoardTest do
  use ExUnit.Case
  alias Games.TicTacToe.Board

  describe "testing mark/3" do
    test "will mark an empty spot" do
      board = Board.new()
      assert(match?({:ok, _board}, Board.mark(board, [1,1], :x)))
    end
    test "will not mark an occupied spot" do
      {:ok, board} = Board.new()
      |> Board.mark([1,1], :x)
      assert(match?({:error, message}, Board.mark(board, [1,1], :z)))
    end
  end
end
