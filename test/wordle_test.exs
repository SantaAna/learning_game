defmodule WordleTest do
  use ExUnit.Case
  # doctest Wordle

  describe "testing feedback/2 check rounds" do
    test "returns all green for exact match" do
      assert Wordle.feedback("race", "race") === [:green, :green, :green, :green]
    end
    test "returns partial green for inexact match" do
      assert Wordle.feedback("pace", "race") == [:gray, :green, :green, :green]
    end
    test "returns yellow for out of place character"

  end
end
