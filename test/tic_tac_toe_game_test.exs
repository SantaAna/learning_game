defmodule TicTacToeGameTest do
  use ExUnit.Case
  import Mox
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
           {:ok, board} <- Board.mark(board, [1, 1], :x),
           {:ok, board} <- Board.mark(board, [2, 1], :x),
           {:ok, board} <- Board.mark(board, [3, 1], :x) do
        assert(TicTacToe.col_winner(board) == {true, :x})
        assert(TicTacToe.row_winner(board) == :no_winner)
        assert(TicTacToe.diag_winner(board) == :no_winner)
      end
    end

    test "row_winner recognizes row winner, no others return winner" do
      with board <- Board.new(),
           {:ok, board} <- Board.mark(board, [1, 1], :x),
           {:ok, board} <- Board.mark(board, [1, 2], :x),
           {:ok, board} <- Board.mark(board, [1, 3], :x) do
        assert(TicTacToe.col_winner(board) == :no_winner)
        assert(TicTacToe.row_winner(board) == {true, :x})
        assert(TicTacToe.diag_winner(board) == :no_winner)
      end
    end

    test "diag_winner recognizes left to right winner, no others return winner" do
      with board <- Board.new(),
           {:ok, board} <- Board.mark(board, [1, 1], :x),
           {:ok, board} <- Board.mark(board, [2, 2], :x),
           {:ok, board} <- Board.mark(board, [3, 3], :x) do
        assert(TicTacToe.col_winner(board) == :no_winner)
        assert(TicTacToe.row_winner(board) == :no_winner)
        assert(TicTacToe.diag_winner(board) == {true, :x})
      end
    end

    test "diag_winner recognizes right to left winner, no others return winner" do
      with board <- Board.new(),
           {:ok, board} <- Board.mark(board, [1, 3], :x),
           {:ok, board} <- Board.mark(board, [2, 2], :x),
           {:ok, board} <- Board.mark(board, [3, 1], :x) do
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
           {:ok, board} <- Board.mark(board, [1, 1], :x),
           {:ok, board} <- Board.mark(board, [1, 2], :x),
           {:ok, board} <- Board.mark(board, [1, 3], :x) do
        assert(TicTacToe.winner(board) == {true, :x})
      end
    end

    test "returns {true, :o} for an :o winner" do
      with board <- Board.new(),
           {:ok, board} <- Board.mark(board, [1, 1], :o),
           {:ok, board} <- Board.mark(board, [1, 2], :o),
           {:ok, board} <- Board.mark(board, [1, 3], :o) do
        assert(TicTacToe.winner(board) == {true, :o})
      end
    end
  end

  describe "play/1" do
    test "recognizes a player win" do
      expect(Games.TicTacToe.MockDisplay, :display_feedback, 2, fn _ -> nil end)
      expect(Games.TicTacToe.MockDisplay, :get_user_input, 1, fn _ -> [1, 3] end)
      expect(Games.TicTacToe.MockDisplay, :victory, 1, fn _ -> nil end)

      with board <- Board.new(),
           {:ok, board} <- Board.mark(board, [1, 1], :x),
           {:ok, board} <- Board.mark(board, [1, 2], :x) do
        TicTacToe.play(%Games.TicTacToe{board: board})
      end

      verify!(Games.TicTacToe.MockDisplay)
    end

    test "recognizes a computer win" do
      expect(Games.TicTacToe.MockDisplay, :display_feedback, 2, fn _ -> nil end)
      expect(Games.TicTacToe.MockDisplay, :get_user_input, 1, fn _ -> [2, 3] end)
      expect(Games.TicTacToe.MockDisplay, :defeat, 1, fn _ -> nil end)

      with board <- Board.new(),
           {:ok, board} <- Board.mark(board, [1, 1], :x),
           {:ok, board} <- Board.mark(board, [1, 2], :o),
           {:ok, board} <- Board.mark(board, [1, 3], :x),
           {:ok, board} <- Board.mark(board, [2, 1], :o),
           {:ok, board} <- Board.mark(board, [2, 2], :x),
           {:ok, board} <- Board.mark(board, [3, 1], :o),
           {:ok, board} <- Board.mark(board, [3, 3], :o) do
        TicTacToe.play(%Games.TicTacToe{board: board})
      end
    end
    
    test "recognizes a draw" do
      expect(Games.TicTacToe.MockDisplay, :display_feedback, 2, fn _ -> nil end)
      expect(Games.TicTacToe.MockDisplay, :get_user_input, 1, fn _ -> [3, 2] end)
      expect(Games.TicTacToe.MockDisplay, :draw, 1, fn _ -> nil end)

      with board <- Board.new(),
           {:ok, board} <- Board.mark(board, [1, 1], :x),
           {:ok, board} <- Board.mark(board, [1, 2], :o),
           {:ok, board} <- Board.mark(board, [1, 3], :x),
           {:ok, board} <- Board.mark(board, [2, 1], :o),
           {:ok, board} <- Board.mark(board, [2, 2], :x),
           {:ok, board} <- Board.mark(board, [3, 1], :o),
           {:ok, board} <- Board.mark(board, [3, 3], :o) do
        TicTacToe.play(%Games.TicTacToe{board: board})
      end
    end
  end
end
