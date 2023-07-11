defmodule Games.Supervisor do
  use Supervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, [])
  end

  @impl true
  def init(:ok) do
    children = [
      %{
        id: Games.TicTacToe.ComputerMoveServer,
        start: {Games.TicTacToe.ComputerMoveServer, :start_link, [["resources/move_cache"]]}
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
