ExUnit.start()

Mox.defmock(Application.get_env(:games, :wordle_display_module), for: Games.Display.Behaviour)
Mox.defmock(Application.get_env(:games, :tic_tac_toe_display_module), for: Games.Display.Behaviour)
