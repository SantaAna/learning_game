defmodule Wordle do
  @word_path "./resources/words.txt"
  alias Wordle.Display

  def play() do
    Wordle.Display.welcome()
    Wordle.Display.instructions()
    winning_word = random_word()
    play(winning_word, 1)
  end

  def play(winning_word, 7), do: Display.defeat(winning_word)

  def play(winning_word, round_count) do
    player_guess = Wordle.Display.get_user_input()
    feedback = feedback(winning_word, player_guess)

    if win?(feedback) do
      Wordle.Display.victory()
    else
      Display.display_feedback({player_guess, feedback}, round_count)
      play(winning_word, round_count + 1)
    end
  end

  @spec random_word(integer) :: String.t()
  def random_word(length \\ 6) do
    File.stream!(@word_path)
    |> Stream.map(&String.trim/1)
    |> Stream.filter(&(String.length(&1) == length))
    |> Enum.random()
  end

  def win?(feedback) do
    Enum.all?(feedback, &(&1 == :green))
  end

  def feedback(target_word, guessed_word) do
    {String.graphemes(target_word), String.graphemes(guessed_word)}
    |> find_greens()
    |> find_yellows()
    |> find_reds()
  end

  def find_greens({target_chars, guessed_chars}) do
    Enum.zip([target_chars, guessed_chars])
    |> Enum.map(fn
      {same, same} -> {nil, :green}
      {tar, guess} -> {tar, guess}
    end)
    |> Enum.unzip()
  end

  def find_yellows({target_chars, guessed_chars}) do
    Enum.reduce(guessed_chars, {target_chars, []}, fn guess, {target_chars, updated} ->
      if guess in target_chars do
        {List.delete(target_chars, guess), List.insert_at(updated, -1, :yellow)}
      else
        {target_chars, List.insert_at(updated, -1, guess)}
      end
    end)
  end

  def find_reds({_target_chars, guessed_chars}) do
    Enum.map(guessed_chars, fn char -> 
      if char not in [:yellow, :green] do
        :red
      else
        char
      end
    end) 
  end

  def count_chars(string) do
    String.graphemes(string)
    |> Enum.frequencies()
  end
end
