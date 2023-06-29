defmodule Games.GuessingGame.Display do
  def welcome() do
    Owl.Box.new("Guessing Game", padding_x: 34)
    |> Owl.IO.puts()
  end

  def instructions(max_number \\ 10) do
    [
      "Try to guess a random number between 1 and #{max_number}",
      "\n\n",
      "After you enter a guess you will receive feedback:",
      "\n",
      "* If you guess too low: ",
      Owl.Data.tag("too low", :yellow),
      "\n",
      "* If you guess too high: ",
      Owl.Data.tag("too high", :yellow)
    ]
    |> Owl.Box.new(title: "Rules", max_width: 76)
    |> Owl.IO.puts()
  end

  def display_feedback(:too_low) do
    Owl.Data.tag("too low", :yellow)
    |> Owl.IO.puts()
  end

  def display_feedback(:too_high) do
    Owl.Data.tag("too high", :yellow)
    |> Owl.IO.puts()
  end

  def get_user_input(max_number \\ 10) do
    Owl.IO.input(
      label: "Enter a guess between 1 and #{max_number}",
      cast: {:integer, min: 1, max: max_number}
    )
  end

  def victory() do
    Owl.Data.tag("You Win!", :green)
    |> Owl.Box.new(padding_x: 34, border_tag: :green)
    |> Owl.IO.puts()

    Process.sleep(1000)
    Games.Menu.display_main_menu()
  end
end
