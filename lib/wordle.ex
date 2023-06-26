defmodule Wordle do
  @spec feedback(String.t() , String.t()) :: list()
  def feedback(target_word, guessed_word) do
    Enum.zip([String.graphemes(target_word), String.graphemes(guessed_word)])
    |> Enum.map(fn
      {same, same} -> :green
      {_tar_char, guess_char} ->
      if guess_char in String.graphemes(target_word) do
        :yellow
      else
        :gray
      end
    end)
  end
end
