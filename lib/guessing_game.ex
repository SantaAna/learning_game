defmodule GuessingGame do
  def play() do  
    winning_number = Enum.random(1..10)
    inital_choice = get_input()
    play(inital_choice, winning_number)
  end

  def play(num, num), do: IO.puts("You Win! The winning number was #{num}")

  def play(guess, winner) when guess > winner do
    IO.puts("Your guess was too high, guess again")
    play(get_input(), winner)
  end

  def play(guess, winner) when guess < winner do
    IO.puts("Your guess was too low, guess again")
    play(get_input(), winner)
  end

  def get_input() do
    input_string = IO.gets("Guess a number between 1 and 10: ") 
    |> String.trim() 

    case Integer.parse(input_string) do
      {value, _rest} -> value  
      :error -> 
        IO.puts("Invalid input, input must be a number between one and ten.")
        get_input()
    end
  end
end
