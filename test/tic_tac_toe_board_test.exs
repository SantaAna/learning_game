defmodule TicTacToeBoardTest do
  use ExUnit.Case
  alias Games.TicTacToe.Board

  describe "testing mark/3" do
    test "will mark an empty spot" do
      board = Board.new()
      assert(match?({:ok, _board}, Board.mark(board, [1, 1], :x)))
    end

    test "will not mark an occupied spot" do
      {:ok, board} =
        Board.new()
        |> Board.mark([1, 1], :x)

      assert(match?({:error, message}, Board.mark(board, [1, 1], :z)))
    end
  end

  describe "testing fully_marked/1" do
    test "will return false if the board is blank" do
      board = Board.new()
      assert(Board.fully_marked?(board) == false)
    end

    test "will return true for board of all the same marker" do
      board = Board.new()

      board =
        for x <- 1..board.size, y <- 1..board.size, reduce: board do
          board ->
            {:ok, board} = Board.mark(board, [x, y], :x)
            board
        end

      assert(Board.fully_marked?(board) == true)
    end

    test "will return true for board filled with differing markers" do
      board = Board.new()

      board =
        for x <- 1..board.size, y <- 1..board.size, reduce: board do
          board when rem(x, 2) == 0 ->
            {:ok, board} = Board.mark(board, [x, y], :x)
            board
          board ->
            {:ok, board} = Board.mark(board, [x, y], :o)
            board
        end

      assert(Board.fully_marked?(board) == true)
    end
  end

  describe "testing rows/1 and cols/1" do
    test "blank board will return blank rows and columns" do
      board = Board.new()
      cols = Board.cols(board)
      rows = Board.rows(board)

      for {_row_number, row} <- rows do
        assert(Enum.all?(row, fn {_k, v} -> v == :blank end))
      end

      for {_row_number, col} <- cols do
        assert(Enum.all?(col, fn {_k, v} -> v == :blank end))
      end
    end

    test "non blank board will have marks in correct rows/cols" do
      with board <- Board.new(),
           {:ok, board} <- Board.mark(board, [1, 1], :x),
           {:ok, board} <- Board.mark(board, [2, 2], :x),
           {:ok, board} <- Board.mark(board, [3, 3], :x) do
        cols = Board.cols(board)
        rows = Board.rows(board)
        assert(cols[1][[1, 1]] == :x)
        assert(cols[2][[2, 2]] == :x)
        assert(cols[3][[3, 3]] == :x)
        assert(rows[1][[1, 1]] == :x)
        assert(rows[2][[2, 2]] == :x)
        assert(rows[3][[3, 3]] == :x)
      end
    end
  end

  describe "testing diagnoals/1" do
    test "blank board will have blank diagonals" do
      board = Board.new()
      diagonals = Board.diagonals(board)
      assert(Enum.all?(diagonals.left_right_diagonal, fn {_k, v} -> v == :blank end))
      assert(Enum.all?(diagonals.right_left_diagonal, fn {_k, v} -> v == :blank end))
    end

    test "non-blank board will have marks in correct diagonal position" do
      with board <- Board.new(),
           {:ok, board} <- Board.mark(board, [1, 3], :x),
           {:ok, board} <- Board.mark(board, [2, 2], :x) do
        diagonals = Board.diagonals(board)
        assert(diagonals.right_left_diagonal[[1, 3]] == :x)
        assert(diagonals.left_right_diagonal[[2, 2]] == :x)
      end
    end
  end
end
