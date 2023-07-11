defmodule Games.ConnectFour do
  alias Games.ConnectFour.Board
  defstruct [:board, winner: nil, draw: false]
  @type t :: %__MODULE__{board: Board.t(), winner: atom, draw: boolean}
  def winner?(%__MODULE__{board: board}) do
    with :no_winner <- row_winner(board),
         :no_winner <- col_winner(board),
         :no_winner <- diag_winner(board),
         do: :no_winner
  end

  @spec diag_winner(Board.t()) :: {:winner, atom} | :no_winner
  defp diag_winner(board) do
    board
    |> Board.get_diagonals()
    |> Enum.filter(&(length(&1) >= 4))
    |> Enum.map(&four_in_a_row/1)
    |> List.flatten()
    |> Enum.find(:no_winner, fn 
    {:winner, _} -> true 
    _ -> false
    end)
  end

  @spec row_winner(Board.t()) :: {:winner, atom} | :no_winner
  defp row_winner(board) do
    board
    |> Board.get_rows()
    |> Enum.map(&four_in_a_row/1)
    |> List.flatten()
    |> Enum.find(:no_winner, fn 
    {:winner, _} -> true 
    _ -> false
    end)
  end

  @spec col_winner(Board.t()) :: {:winner, atom} | :no_winner
  defp col_winner(board) do
    board
    |> Board.get_cols()
    |> Enum.map(&four_in_a_row/1)
    |> List.flatten()
    |> Enum.find(:no_winner, fn 
    {:winner, _} -> true 
    _ -> false
    end)
  end

  @spec four_in_a_row(list(atom)) :: list({:winner, atom} | false)
  defp four_in_a_row(to_check) do
    to_check
    |> Enum.chunk_every(4, 1, :discard)
    |> Enum.map(&all_same/1)
  end
  
  @spec all_same(list(atom)) :: {:winner, atom} | false
  defp all_same(to_check) do
    first = List.first(to_check)

    if Enum.all?(to_check, &(&1 == first)) and first != :blank do
      {:winner, first}
    else
      false
    end
  end
end
