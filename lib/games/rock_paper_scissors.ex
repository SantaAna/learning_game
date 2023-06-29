defmodule Games.RockPaperScissors do
  alias Games.RockPaperScissors.Display

  @winner %{
    {"rock", "scissors"} => true,
    {"scissors", "paper"} => true,
    {"paper", "rock"} => true
  }

  @choices ["paper", "rock", "scissors"]

  @spec play() :: any()
  def play() do
    Display.instructions()
    play(Display.get_user_input())
  end

  def play(user_choice) do
    computer_choice = computer_choice()
    Display.display_feed_back(computer_choice, user_choice)
    case result(computer_choice, user_choice) do
      :computer_wins -> Display.defeat()
      :user_wins -> Display.victory()
      :draw -> Display.draw()
    end
  end

  @spec result(String.t(), String.t()) :: :computer_wins | :user_wins | :draw
  def result(comp_choice, player_choice) do
    case {@winner[{comp_choice, player_choice}], @winner[{player_choice, comp_choice}]} do
      {true, _} ->
        :computer_wins

      {_, true} ->
        :user_wins

      _ ->
        :draw
    end
  end

  @spec computer_choice() :: String.t()
  def computer_choice() do
    Enum.random(@choices)
  end
end
