defmodule Games.RockPaperScissors do
  alias Games.RockPaperScissors.Display
  @winner %{
    {"rock", "scissors"} => true, 
    {"scissors", "paper"} => true,
    {"paper", "rock"} => true 
  }

  @choices ["paper", "rock", "scissors"]

  @spec play() :: :ok
  def play() do
    Display.instructions()
    result(computer_choice(), Display.get_user_input())
  end
  
  @spec result(String.t(), String.t()) :: :ok
  def result(comp_choice, player_choice) do
    case {@winner[{comp_choice, player_choice}], @winner[{player_choice, comp_choice}]} do
      {true, _} -> 
        Display.display_feed_back(comp_choice, player_choice) 
        Display.defeat()
      {_, true} -> 
        Display.display_feed_back(comp_choice, player_choice) 
        Display.victory()
      _ ->
        Display.display_feed_back(comp_choice, player_choice) 
        Display.draw()
    end
  end
  
  @spec computer_choice() :: String.t()
  def computer_choice() do
    Enum.random(@choices)
  end
end
