defmodule Games.Wordle do
  @word_path "./resources/words.txt"
  @display_module Application.compile_env(
                    :games,
                    :wordle_display_module,
                    Games.Wordle.Display
                  )

  defstruct [:winning_word, :player_guess, :feed_back, round_count: 1]

  alias Games.Wordle.Display

  def play() do
    Display.welcome()
    Display.instructions()
    play(%__MODULE__{winning_word: random_word()})
  end

  def play(%__MODULE__{round_count: 7} = game), do: @display_module.defeat(game)

  def play(%__MODULE__{} = game) do
    game
    |> advance_round()
    |> update_player_guess()
    |> game_feedback()
    |> continue_decision()
  end

  def advance_round(%__MODULE__{} = game), do: Map.update!(game, :round_count, & &1 + 1) 

  def update_player_guess(%__MODULE__{} = game) do
    Map.put(game, :player_guess, @display_module.get_user_input(6)) 
  end

  def game_feedback(%__MODULE__{player_guess: player_guess, winning_word: winning_word} = game) do
    Map.put(game, :feed_back, feedback(winning_word, player_guess))
  end

  def continue_decision(%__MODULE__{} = game) do
    if win?(game) do 
      @display_module.victory(game)
    else
      @display_module.display_feedback(game)
      play(game)
    end
  end


  @spec random_word(integer) :: String.t()
  def random_word(length \\ 6) do
    File.stream!(@word_path)
    |> Stream.map(&String.trim/1)
    |> Stream.filter(&(String.length(&1) == length))
    |> Enum.random()
  end

  def win?(%__MODULE__{feed_back: feedback}) do
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
      if char in [:yellow, :green] do
        char
      else
        :red
      end
    end)
  end
end
