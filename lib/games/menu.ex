defmodule Games.Menu do
  def main(_), do: welcome()

  def display_main_menu() do
    instructions()
    %{launch_function: launch} = games_menu()
    launch.()
  end

  def welcome() do
    display_welcome()
    instructions()
    %{launch_function: launch} = games_menu()
    launch.()
  end

  def display_welcome() do
    Owl.Box.new("Games", padding_x: 34)
    |> Owl.IO.puts()
  end

  def instructions() do
    [
      "Pick one of the games below, or press <ctrl> + c to quit."
    ]
    |> Owl.Box.new(title: "Instructions", max_width: 76)
    |> Owl.IO.puts()
  end

  def games_menu() do
    games = [
      %{
        name: "Wordle",
        description: "Try to guess a random word using hints from previous guesses.",
        launch_function: &Games.Wordle.play/0
      },
      %{
        name: "Guessing Game",
        description: "Try to guess a random number using hits from previous guesses.",
        launch_function: &Games.GuessingGame.play/0
      },
      %{
        name: "Rock Paper Scissors",
        description: "Try to beat the computer at the ancient game of rock, paper, scissors.",
        launch_function: &Games.RockPaperScissors.play/0
      },
      %{
        name: "Tic-Tac-Toe",
        description: "Try to beat the computer at Tic-Tac-Toe",
        launch_function: &Games.TicTacToe.play/0
      },
      %{
        name: "Connect Four",
        description: "Try to connect four before the computer.",
        launch_function: &Games.ConnectFour.play/0
      }
    ]

    Owl.IO.select(games,
      render_as: fn %{name: name, description: desc} ->
        [Owl.Data.tag(name, :cyan), "\n", desc]
      end
    )
  end
end
