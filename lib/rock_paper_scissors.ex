defmodule RockPaperScissors do
  @winner %{
    {"rock", "scissors"} => true, 
    {"scissors", "paper"} => true,
    {"paper", "rock"} => true 
  }

  @choices ["paper", "rock", "scissors"]

  def play() do
    IO.puts("rock, paper, scissors, shoot!")
    result(computer_choice(), human_choice())
  end

  def result(comp_choice, player_choice) do
    case {@winner[{comp_choice, player_choice}], @winner[{player_choice, comp_choice}]} do
      {:winner, _} -> IO.puts("computer wins, c: #{comp_choice}, p: #{player_choice}")
      {_, :winner} -> IO.puts("you win, c: #{comp_choice}, p: #{player_choice}")
      _ -> IO.puts("draw! c: #{comp_choice}, p: #{player_choice}")
    end
  end

  def computer_choice() do
    Enum.random(@choices)
  end

  def human_choice() do
    input =
      IO.gets("choose rock paper scissors: ")
      |> String.trim()

    if input in @choices do
      input
    else
      IO.puts("invalid input, must choose rock, paper, scissors")
      human_choice()
    end
  end
end
