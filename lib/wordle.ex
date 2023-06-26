defmodule Wordle do
  @spec feedback(String.t(), String.t()) :: list()
  def feedback(target_word, guessed_word) do
    target_counts = count_chars(target_word)

    {green_matches, remaining_counts} =
      Enum.zip([String.graphemes(target_word), String.graphemes(guessed_word)])
      |> Enum.reduce({[], target_counts}, fn {target_char, guess_char}, {so_far, target_counts} ->
        case {target_char, guess_char} do
          {same, same} ->
            {[:green | so_far], Map.update!(target_counts, same, &(&1 - 1))}

          {_target_char, guess_char} ->
            {[guess_char | so_far], target_counts}
        end
      end)

    Enum.reduce(green_matches, {[], remaining_counts}, fn
      :green, {so_far, remaining_counts} ->
        {[:green | so_far], remaining_counts}

      char, {so_far, remaining_counts} ->
        case remaining_counts[char] do
          nil -> {[:gray | so_far], remaining_counts}
          0 -> {[:gray | so_far], remaining_counts}
          _ -> {[:yellow | so_far], Map.update!(remaining_counts, char, &(&1 - 1))}
        end
    end)
    |> elem(0)
  end

  def count_chars(string) do
    String.graphemes(string)
    |> Enum.frequencies()
  end
end
