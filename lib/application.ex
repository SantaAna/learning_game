defmodule Games.Application do
  use Application
  def start(_type, _args) do
    Games.Supervisor.start_link(nil)
  end
end
