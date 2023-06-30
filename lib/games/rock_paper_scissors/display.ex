defmodule Games.RockPaperScissors.Display do
  @behaviour Games.Display.Behaviour

  def welcome() do
    Owl.Box.new("Rock Paper Scissors", padding_x: 34)
    |> Owl.IO.puts()
  end

  def instructions(_) do
    [
      "Try to beat the computer by throwing rock, paper, or scissors"
    ]
    |> Owl.Box.new(title: "Rules", max_width: 76)
    |> Owl.IO.puts()
  end

  def get_user_input(_) do
    Owl.IO.select(["rock", "paper", "scissors"],
      render_as: fn name ->
        [Owl.Data.tag(name, :cyan)]
      end
    )
  end

  def draw() do
    Owl.Data.tag("Draw", :yellow)
    |> Owl.Box.new(padding_x: 34, border_tag: :yellow)
    |> Owl.IO.puts()

    Process.sleep(1000)
    Games.Menu.display_main_menu()
  end

  def defeat(_) do
    Owl.Data.tag("You Lose", :red)
    |> Owl.Box.new(padding_x: 34, border_tag: :red)
    |> Owl.IO.puts()

    Process.sleep(1000)
    Games.Menu.display_main_menu()
  end

  def victory() do
    Owl.Data.tag("You Win!", :green)
    |> Owl.Box.new(padding_x: 34, border_tag: :green)
    |> Owl.IO.puts()

    Process.sleep(1000)
    Games.Menu.display_main_menu()
  end

  def display_feedback({computer_play, human_play}) do
    [
      Owl.Data.tag("You play #{human_play}", :green),
      "\n",
      Owl.Data.tag("Computer plays #{computer_play}", :red)
    ]
    |> Owl.IO.puts()
  end
end
