defmodule Games.TicTacToe.ComputerMoveServer do
  use GenServer
  alias Games.TicTacToe.ComputerPlayer

  # public
  def start_link(cache_file) do
    cache =
      case File.read(cache_file) do
        {:ok, file} -> :erlang.binary_to_term(file)
        {:error, :enoent} -> %{}
      end

    GenServer.start_link(__MODULE__, {cache, cache_file}, name: __MODULE__)
  end

  def get_move(board) do
    GenServer.call(__MODULE__, {:move, board})
  end

  def persist_cache() do
    GenServer.call(__MODULE__, :persist)
  end

  # private
  @impl true
  def init(cache) do
    {:ok, cache}
  end

  @impl true
  def handle_call({:move, board}, _from, {cache, cache_file}) do
    if cache_result = Map.get(cache, board) do
      {:reply, cache_result, {cache, cache_file}}
    else
      computer_move = ComputerPlayer.move(board, :perfect)
      {:reply, computer_move, {Map.put(cache, board, computer_move), cache_file}}
    end
  end

  @impl true
  def handle_call(:persist, _from, {cache, cache_file} = state) do
    File.write!(
      cache_file,
      :erlang.term_to_binary(cache)
    )

    {:reply, :ok, state}
  end
end
