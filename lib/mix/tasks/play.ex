defmodule Mix.Tasks.Play do
  use Mix.Task

  def run(["wordle"]) do
    Mix.Task.run("app.start")
    Games.Wordle.play()
  end

  def run([]) do
    Mix.Task.run("app.start")
    Games.Menu.welcome()
  end
end
