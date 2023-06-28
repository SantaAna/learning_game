defmodule WordleTest do
  use ExUnit.Case
  # doctest Wordle

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

    # test "returns all gray for 0 character matches" do
    #   assert Wordle.feedback("jimbob", "ranchy")
    # end

    # test "returns 3 yellow for out of place characters" do
    #   assert Wordle.feedback("shrimp", "blimpy")
    # end

    test "returns 3 yellow for out of place characters" do
      assert Wordle.feedback("glimpse", "sssssss") == [
               :red,
               :red,
               :red,
               :red,
               :red,
               :green,
               :red
             ]
    end
  end
end
