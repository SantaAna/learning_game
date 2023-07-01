import Config

case config_env() do
  :test ->
    config :games, wordle_display_module: Games.Wordle.MockDisplay
  :dev ->
    nil

  :prod ->
    nil
end
