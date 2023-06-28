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
    |> Stream.filter(& String.length(&1) == length)
    |> Enum.random()
  end

  def win?(feedback) do
    Enum.all?(feedback, & &1 == :green)
  end

  @spec feedback(String.t(), String.t()) :: list(:gray | :yellow | :green)
  def feedback(target_word, guessed_word) do
    target_counts = count_chars(target_word)

    {instructions, remaining_counts} =
      Enum.zip([String.graphemes(target_word), String.graphemes(guessed_word)])
      |> Enum.reduce({[], target_counts}, fn {target_char, guess_char}, {so_far, target_counts} ->
        case {target_char, guess_char} do
          {same, same} ->
            f = make_checker_function(:green)
            {[f | so_far], Map.update!(target_counts, same, &(&1 - 1))}

          {_target_char, guess_char} ->
            f = make_checker_function(guess_char)
            {[f | so_far], target_counts}
        end
      end)

    Enum.reduce(instructions, {[], remaining_counts}, fn
      f, acc ->
        f.(acc)
    end)
    |> elem(0)
  end
  
  @spec make_checker_function(:green | String.t()) :: ({list, map} -> {list, map})
  def make_checker_function(:green),
    do: fn {so_far, remaining_counts} -> {[:green | so_far], remaining_counts} end

  def make_checker_function(guess_char) do
    fn {so_far, remaining_counts} ->
      if Map.get(remaining_counts, guess_char, 0) == 0 do
        {[:red | so_far], remaining_counts}
      else
        {[:yellow | so_far], Map.update!(remaining_counts, guess_char, &(&1 - 1))}
      end
    end
  end

  def count_chars(string) do
    String.graphemes(string)
    |> Enum.frequencies()
  end
end
