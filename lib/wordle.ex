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
            f = fn {so_far, remaining_counts} ->
              if Map.get(remaining_counts, guess_char, 0) == 0 do
                {[:gray | so_far], remaining_counts}
              else
                {[:yellow | so_far], Map.update!(remaining_counts, guess_char, &(&1 - 1))}
              end
            end

            {[f | so_far], target_counts}
        end
      end)

    Enum.reduce(green_matches, {[], remaining_counts}, fn
      :green, {so_far, remaining_counts} ->
        {[:green | so_far], remaining_counts}

      f, acc ->
        f.(acc)
    end)
    |> elem(0)
  end

  def count_chars(string) do
    String.graphemes(string)
    |> Enum.frequencies()
  end
end
