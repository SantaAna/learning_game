defmodule Games.TicTacToe.Display do
  @behaviour Games.Display.Behaviour
  alias Games.TicTacToe.Board

  def welcome() do
    Owl.Box.new(Owl.Data.tag("Tic-Tac-Toe", :italic), padding_x: 34)
    |> Owl.IO.puts()
  end

  def instructions(_) do
    [
      "Try to beat the computer at tic-tac-toe",
      "\n\n",
      "Row 1 is at the top, and col 1 is the left-most column",
      "\n",
      "Choose where to place your X by entering co-ordinates in row,col format",
      "\n",
      "The first to get three in a row is the winner!",
      "\n",
      ""
    ]
    |> Owl.Box.new(title: "Rules", max_width: 76)
    |> Owl.IO.puts()
  end

  def victory(_game) do
    Owl.Data.tag("You Win!", :green)
    |> Owl.Box.new(padding_x: 34, border_tag: :green)
    |> Owl.IO.puts()

    Process.sleep(1000)
    Games.Menu.display_main_menu()
  end

  def defeat(_game) do
    Owl.Data.tag("You Lose", :red)
    |> Owl.Box.new(padding_x: 34, border_tag: :red)
    |> Owl.IO.puts()

    Process.sleep(1000)
    Games.Menu.display_main_menu()
  end

  def draw(_game) do
    Owl.Data.tag("Cat's game!", :yellow)
    |> Owl.Box.new(padding_x: 34, border_tag: :yellow)
    |> Owl.IO.puts()

    Process.sleep(1000)
    Games.Menu.display_main_menu()
  end

  def display_feedback(%{board: board}) do
    Board.rows(board)
    |> strip_row_nums()
    |> to_represenations()
    |> add_seperators()
    |> add_newlines()
    |> add_row_seperators()
    |> Owl.Box.new(title: "Board")
    |> Owl.IO.puts()
  end

  defp add_row_seperators(rows), do: Enum.join(rows, "#####\n")

  defp strip_row_nums(rows) do
    rows
    |> Map.values()
    |> Enum.map(&Map.values/1)
  end

  defp to_represenations(rows) do
    Enum.map(rows, fn row ->
      Enum.map(row, fn
        :blank -> " "
        ele -> Atom.to_string(ele)
      end)
    end)
  end

  defp add_seperators(rows) do
    Enum.map(rows, &Enum.join(&1, "#"))
  end

  defp add_newlines(rows) do
    Enum.map(rows, &(&1 <> "\n"))
  end

  def get_user_input(%{board: board}) do
    Owl.IO.input(
      label: "Enter the co-ordinate to place your next X",
      cast: fn input ->
        with {:ok, input} <- contains_comma(input),
             str_coords <- split_coords(input),
             {:ok, coords} <- coords_to_integer(str_coords),
             {:ok, coords} <- check_spot_available(coords, board) do
          {:ok, coords}
        end
      end
    )
  end

  defp check_spot_available(coords, board) do
    IO.puts(coords)
    if Board.is_blank?(board, coords) do
      {:ok, coords}
    else
      {:error, "spot is taken, chose an empty spot."}
    end
  end

  defp coords_to_integer([str_row, str_col]) do
    case [Integer.parse(str_row), Integer.parse(str_col)] do
      [:error, _] -> {:error, "both co-ordinates must be integers"}
      [_, :error] -> {:error, "both co-ordinates must be integers"}
      [{row, _}, {col, _}] -> {:ok, [row, col]}
    end
  end

  defp split_coords(string) do
    String.split(string, ",")
    |> Enum.map(&String.trim/1)
  end

  defp contains_comma(string) do
    if String.contains?(string, ",") do
      {:ok, string}
    else
      {:error, "co-ordinates must be separated by a comma."}
    end
  end
end
