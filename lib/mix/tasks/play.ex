defmodule Mix.Tasks.Play do
  use Mix.Task 

  def run(_args) do
    Mix.Task.run("app.start")
    Logger.configure_backend(:console, device: Owl.LiveScreen)
    Wordle.play()
  end
end
