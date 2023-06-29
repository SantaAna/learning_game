defmodule RockPaperScissorsTest do
  use ExUnit.Case
  alias Games.RockPaperScissors

  test "rock beats scissors" do 
    assert RockPaperScissors.result("rock", "scissors") == :computer_wins
  end

  test "paper beats rock" do
    assert RockPaperScissors.result("paper", "rock") == :computer_wins
  end

  test "scissors beats paper" do
    assert RockPaperScissors.result("scissors", "paper") == :computer_wins
  end

  test "same draws with same" do
    assert RockPaperScissors.result("rock", "rock") == :draw
    assert RockPaperScissors.result("scissors", "scissors") == :draw
    assert RockPaperScissors.result("paper", "paper") == :draw
  end
end
