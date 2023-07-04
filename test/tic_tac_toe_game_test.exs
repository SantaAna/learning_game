defmodule TicTacToeGameTest do
  use ExUnit.Case
  alias Games.TicTacToe.Board
  alias Games.TicTacToe

  describe "test for row_winner/1 col_winner/1 diag_winner/1" do
    test "all retrun :no_winner for blank board" do
      board = Board.new()
      assert(TicTacToe.row_winner(board) == :no_winner)
      assert(TicTacToe.col_winner(board) == :no_winner)
      assert(TicTacToe.diag_winner(board) == :no_winner)
    end

    test "col_winner recognizes column winner, no others return winner" do
      with board <- Board.new(),
          {:ok, board} <- Board.mark(board, [1,1], :x),
          {:ok, board} <- Board.mark(board, [2,1], :x),
          {:ok, board} <- Board.mark(board, [3,1], :x) do
            assert(TicTacToe.col_winner(board) == {true, :x})
            assert(TicTacToe.row_winner(board) == :no_winner)
            assert(TicTacToe.diag_winner(board) == :no_winner)
      end
    end

    test "row_winner recognizes row winner, no others return winner" do
      with board <- Board.new(),
          {:ok, board} <- Board.mark(board, [1,1], :x),
          {:ok, board} <- Board.mark(board, [1,2], :x),
          {:ok, board} <- Board.mark(board, [1,3], :x) do
            assert(TicTacToe.col_winner(board) == :no_winner)
            assert(TicTacToe.row_winner(board) == {true, :x})
            assert(TicTacToe.diag_winner(board) == :no_winner)
      end
    end

    test "diag_winner recognizes left to right winner, no others return winner" do
      with board <- Board.new(),
          {:ok, board} <- Board.mark(board, [1,1], :x),
          {:ok, board} <- Board.mark(board, [2,2], :x),
          {:ok, board} <- Board.mark(board, [3,3], :x) do
            assert(TicTacToe.col_winner(board) == :no_winner)
            assert(TicTacToe.row_winner(board) == :no_winner)
            assert(TicTacToe.diag_winner(board) == {true, :x})
      end
    end

    test "diag_winner recognizes right to left winner, no others return winner" do
      with board <- Board.new(),
          {:ok, board} <- Board.mark(board, [1,3], :x),
          {:ok, board} <- Board.mark(board, [2,2], :x),
          {:ok, board} <- Board.mark(board, [3,1], :x) do
            assert(TicTacToe.col_winner(board) == :no_winner)
            assert(TicTacToe.row_winner(board) == :no_winner)
            assert(TicTacToe.diag_winner(board) == {true, :x})
      end
    end
  end

  describe "winner/1" do
    test "returns :no_winner for blank board" do
      board = Board.new()
      assert(TicTacToe.winner(board) == :no_winner)
    end

    test "returns {true, :x} for an :x winner" do
      with board <- Board.new(),
          {:ok, board} <- Board.mark(board, [1,1], :x),
          {:ok, board} <- Board.mark(board, [1,2], :x),
          {:ok, board} <- Board.mark(board, [1,3], :x) do
            assert(TicTacToe.winner(board) == {true, :x})
          end
    end

    test "returns {true, :o} for an :o winner" do
     
      with board <- Board.new(),
          {:ok, board} <- Board.mark(board, [1,1], :o),
          {:ok, board} <- Board.mark(board, [1,2], :o),
          {:ok, board} <- Board.mark(board, [1,3], :o) do
            assert(TicTacToe.winner(board) == {true, :o})
          end
    end
  end
end
