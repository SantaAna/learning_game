defmodule Games.Wordle.Display do
  @behaviour Games.Display.Behaviour

  def welcome() do
    Owl.Box.new(Owl.Data.tag("Wordle", :italic), padding_x: 34)
    |> Owl.IO.puts()
  end

  def instructions(word_length \\ 6) do
    [
      "Try to guess a random english word of length #{word_length} in six tries!",
      "\n\n",
      "After you enter a guess you will receive feedback:",
      "\n",
      "* A letter displayed in ",
      Owl.Data.tag("green", :green),
      " means you guessed correctly",
      "\n",
      "* A letter displayed in ",
      Owl.Data.tag("yellow", :yellow),
      " means the letter is in the word, but not in the right place",
      "\n",
      "* A letter displayed in ",
      Owl.Data.tag("red", :red),
      " means the letter does not occur in the word"
    ]
    |> Owl.Box.new(title: "Rules", max_width: 76)
    |> Owl.IO.puts()
  end

  defp convert_guess_feedback_to_data({guess, feedback}) do
    [String.graphemes(guess), feedback]
    |> Enum.zip()
    |> Enum.map(fn {letter, tag} ->
      Owl.Data.tag(letter, tag)
    end)
  end

  def display_feedback({guess, round_count}) do
    (["guess #{round_count} feedback: "] ++ convert_guess_feedback_to_data(guess))
    |> Owl.IO.puts()
  end

  def defeat(winning_word) do
    Owl.Data.tag("You Lose\nThe word was: #{winning_word}", :red)
    |> Owl.Box.new(padding_x: 34, border_tag: :red)
    |> Owl.IO.puts()

    Process.sleep(1000)
    Games.Menu.display_main_menu()
  end

  def victory() do{}
    Owl.Data.tag("You Win!", :green)
    |> Owl.Box.new(padding_x: 34, border_tag: :green)
    |> Owl.IO.puts()

    Process.sleep(1000)
    Games.Menu.display_main_menu()
  end

  def get_user_input(word_length) do
    Owl.IO.input(
      label: "Enter your guess, word length is #{word_length}",
      cast: fn input ->
        input_length = String.length(input)

        cond do
          input_length == word_length -> {:ok, input}
          input_length < word_length -> {:error, "your input is too short!"}
          input_length > word_length -> {:error, "your input is too long!"}
        end
      end
    )
  end
end
