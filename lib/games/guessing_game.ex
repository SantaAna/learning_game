defmodule Games.GuessingGame do
  alias Games.GuessingGame.Display
  @spec play() :: :ok
  def play() do
    winning_number = Enum.random(1..10)
    inital_choice = Display.get_user_input()
    play(inital_choice, winning_number)
  end

  @spec play(integer, integer) :: :ok
  def play(num, num), do: Display.victory()

  def play(guess, winner) when guess > winner do
    Display.display_feedback(:too_high)
    play(Display.get_user_input(), winner)
  end

  def play(guess, winner) when guess < winner do
    Display.display_feedback(:too_low)
    play(Display.get_user_input(), winner)
  end
end
