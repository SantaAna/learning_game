defmodule Games.ConnectFour.Display do
  @behaviour Games.Display.Behaviour
  alias Games.ConnectFour.Board

  @marker_to_character %{
    :blank => " ",
    :red => Owl.Data.tag("O", :red),
    :black => Owl.Data.tag("O", :black)
  }

  def welcome() do
    Owl.Box.new(Owl.Data.tag("Connect Four", :italic), padding_x: 34)
    |> Owl.IO.puts()
  end

  def instructions(_) do
    [
      "Try to beat the computer at connect four",
      "\n\n",
      "Drop your markers into one of the six columns. You are read and you go first.",
      "\n",
      "The left column is number 1 and the right is number six",
      "\n",
      "The first player to connect four pieces horizontally, vertically, or diagonally wins!",
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
    Owl.Data.tag("Draw!", :yellow)
    |> Owl.Box.new(padding_x: 34, border_tag: :yellow)
    |> Owl.IO.puts()

    Process.sleep(1000)
    Games.Menu.display_main_menu()
  end

  # def display_feedback(%{board: board}) do
  #   Board.rows(board)
  #   |> strip_row_nums()
  #   |> to_represenations()
  #   |> add_seperators()
  #   |> add_newlines()
  #   |> add_row_seperators()
  #   |> Owl.Box.new(title: "Board",  vertical_align: :middle, horizontal_align: :center)
  #   |> Owl.IO.puts()
  # end

  def display_feedback(%{board: board}) do
    board
    |> Board.get_rows()
    |> Enum.map(&render_row/1) 
    |> Enum.intersperse(render_seperator(board.size))
    |> Enum.map(&List.insert_at(&1, -1, "\n"))
    |> List.insert_at(-1, render_seperator(board.size))
    |> Owl.IO.puts()
  end

  def render_seperator(board_size) do
    List.duplicate(Owl.Data.tag("_", :cyan), 2 * board_size + 1)
  end

  def render_row(row) do
      row
      |> Enum.map( &@marker_to_character[&1])
      |> Enum.intersperse(Owl.Data.tag("|", :cyan))
      |> List.insert_at(0, Owl.Data.tag("|", :cyan))
      |> List.insert_at(-1, Owl.Data.tag("|", :cyan))
  end

  def get_user_input(%{board: board}) do
    Owl.IO.select(get_open_cols(board),
      render_as: fn col_num -> "Column #{col_num}" end,
      label: "Enter the column to drop your next marker",
      cast: fn input ->
        String.to_integer(input)
      end
    )
  end

  defp get_open_cols(board) do
    board
    |> Board.open_cols()
    |> Enum.map(&(&1 + 1))
  end
end
