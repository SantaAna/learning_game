defmodule WordleTest do
  use ExUnit.Case
  alias Games.Wordle
  import Mox

  describe "testing feedback/2 check rounds" do
    test "returns all green for exact match" do
      assert Wordle.feedback("race", "race") === [:green, :green, :green, :green]
    end

    test "returns partial green for inexact match" do
      assert Wordle.feedback("pace", "race") === [:red, :green, :green, :green]
    end

    test "returns yellow for out of place character" do
      assert Wordle.feedback("tree", "feet") === [:red, :yellow, :green, :yellow]
    end

    test "returns gray for out of place character which cannot appear again in word" do
      assert Wordle.feedback("treat", "fleet") === [:red, :red, :green, :red, :green]
      assert Wordle.feedback("baab", "aaaa") === [:red, :green, :green, :red]
      assert Wordle.feedback("baba", "aaab") === [:yellow, :green, :red, :yellow]
    end

    test "returns yellow for first out of place matches, and gray if matches 'run out'" do
      assert Wordle.feedback("aabcc", "cabaa") == [:yellow, :green, :green, :yellow, :red]
    end
  end

  describe "testing play/1 function" do
    test "displays winning message if player has won" do
      game_struct = %Wordle{winning_word: "dirkel", round_count: 1} 

      expect(Wordle.MockDisplay, :get_user_input, 1, fn _ ->
        "dirkel"
      end)

      expect(Wordle.MockDisplay, :victory, 1, fn _ -> nil end)
      Wordle.play(game_struct)
      verify!(Wordle.MockDisplay)
    end
  end

  describe "displays defeat message if player has used all guesses" do
    game_struct = %Wordle{winning_word: "dirkel", round_count: 7} 
    expect(Wordle.MockDisplay, :defeat, 1, fn _ -> nil end)
    Wordle.play(game_struct)
    verify!(Wordle.MockDisplay)
  end

  describe "plays an additional round if player guesses incorrectly and there are more tries" do
    game_struct = %Wordle{winning_word: "dirkel", round_count: 6} 
    expect(Wordle.MockDisplay, :display_feedback, 1, fn _ -> nil end)
    expect(Wordle.MockDisplay, :get_user_input, 1, fn _ -> "dirkly" end)
    expect(Wordle.MockDisplay, :defeat, 1, fn _ -> nil end)
    Wordle.play(game_struct)
    verify!(Wordle.MockDisplay)
  end
end
