ExUnit.start()

Mox.defmock(Application.get_env(:games, :wordle_display_module), for: Games.Display.Behaviour)
