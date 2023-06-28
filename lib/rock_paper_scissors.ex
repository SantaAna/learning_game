defmodule RockPaperScissors do
  @winner %{
    {"rock", "scissors"} => true, 
    {"scissors", "paper"} => true,
    {"paper", "rock"} => true 
  }

  @choices ["paper", "rock", "scissors"]

  @spec play() :: :ok
  def play() do
    IO.puts("rock, paper, scissors, shoot!")
    result(computer_choice(), human_choice())
  end
  
  @spec result(String.t(), String.t()) :: :ok
  def result(comp_choice, player_choice) do
    case {@winner[{comp_choice, player_choice}], @winner[{player_choice, comp_choice}]} do
      {:winner, _} -> IO.puts("computer wins, c: #{comp_choice}, p: #{player_choice}")
      {_, :winner} -> IO.puts("you win, c: #{comp_choice}, p: #{player_choice}")
      _ -> IO.puts("draw! c: #{comp_choice}, p: #{player_choice}")
    end
  end
  
  @spec computer_choice() :: String.t()
  def computer_choice() do
    Enum.random(@choices)
  end

  @spec human_choice() :: String.t()
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
