import Config

case config_env() do
  :test ->
    config :games, wordle_display_module: Games.Wordle.MockDisplay
    config :games, tic_tac_toe_display_module: Games.TicTacToe.MockDisplay
  :dev ->
    nil

  :prod ->
    nil
end
