defmodule Mix.Tasks.Play do
  use Mix.Task 

  def run(["wordle"]) do
    Mix.Task.run("app.start")
    Wordle.play()
  end
end
