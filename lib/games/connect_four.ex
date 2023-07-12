defmodule Games.ConnectFour do
  alias Games.ConnectFour.{Board, Display, ComputerPlayer}
  defstruct [:board, computer_difficulty: :perfect, winner: nil, draw: false]
  @type t :: %__MODULE__{board: Board.t(), winner: atom, draw: boolean}

  def play() do
    Display.welcome()
    Display.instructions(nil)
    play(%__MODULE__{board: Board.new(), winner: nil, draw: false})
  end

  def play(%__MODULE__{winner: :player}), do: Display.victory(nil)
  def play(%__MODULE__{winner: :computer}), do: Display.defeat(nil)
  def play(%__MODULE__{draw: true}), do: Display.draw(nil)

  def play(game) do
    game
    |> display_feedback()
    |> player_turn()
    |> win_check()
    |> draw_check()
    |> computer_turn()
    |> win_check()
    |> draw_check()
    |> play()
  end

  def display_feedback(game) do
    Display.display_feedback(game)
    game
  end

  def player_turn(%__MODULE__{winner: winner} = game) when winner != nil, do: game
  def player_turn(%__MODULE__{draw: true} = game), do: game

  def player_turn(%__MODULE__{board: board} = game) do
    player_move = Display.get_user_input(game) - 1
    {:ok, board} = Board.mark(board, player_move, :red)
    Map.put(game, :board, board)
  end

  @spec computer_turn(t) :: t
  def computer_turn(%__MODULE__{winner: winner} = game) when winner != nil, do: game
  def computer_turn(%__MODULE__{draw: true} = game), do: game

  def computer_turn(%__MODULE__{board: board, computer_difficulty: comp_difficulty} = game) do
    computer_move =
      case comp_difficulty do
        :random -> ComputerPlayer.move(board, :random)
        :perfect -> ComputerPlayer.move(board, :perfect)
      end

    {:ok, board} = Board.mark(board, computer_move, :black)
    Map.put(game, :board, board)
  end

  @spec win_check(t) :: t
  def win_check(%__MODULE__{winner: winner} = game) when winner != nil, do: game

  def win_check(%__MODULE__{} = game) do
    case winner(game) do
      :no_winner ->
        game

      {:winner, :red} ->
        Display.display_feedback(game)
        Map.put(game, :winner, :player)

      {:winner, :black} ->
        Display.display_feedback(game)
        Map.put(game, :winner, :computer)
    end
  end

  @spec draw_check(t) :: t
  def draw_check(%__MODULE__{draw: true} = game), do: game
  def draw_check(%__MODULE__{winner: winner} = game) when winner != nil, do: game

  def draw_check(%__MODULE__{} = game) do
    if draw?(game) do
      Display.display_feedback(game)
      Map.put(game, :draw, true)
    else
      game
    end
  end

  def draw?(%__MODULE__{board: board}) do
    Board.full?(board)
  end

  def winner(%__MODULE__{board: board}) do
    with :no_winner <- row_winner(board),
         :no_winner <- col_winner(board),
         :no_winner <- diag_winner(board),
         do: :no_winner
  end

  @spec diag_winner(Board.t()) :: {:winner, atom} | :no_winner
  defp diag_winner(board) do
    board
    |> Board.get_diagonals()
    |> Enum.filter(&(length(&1) >= 4))
    |> Enum.map(&four_in_a_row/1)
    |> List.flatten()
    |> Enum.find(:no_winner, fn
      {:winner, _} -> true
      _ -> false
    end)
  end

  @spec row_winner(Board.t()) :: {:winner, atom} | :no_winner
  defp row_winner(board) do
    board
    |> Board.get_rows()
    |> Enum.map(&four_in_a_row/1)
    |> List.flatten()
    |> Enum.find(:no_winner, fn
      {:winner, _} -> true
      _ -> false
    end)
  end

  @spec col_winner(Board.t()) :: {:winner, atom} | :no_winner
  defp col_winner(board) do
    board
    |> Board.get_cols()
    |> Enum.map(&four_in_a_row/1)
    |> List.flatten()
    |> Enum.find(:no_winner, fn
      {:winner, _} -> true
      _ -> false
    end)
  end

  @spec four_in_a_row(list(atom)) :: list({:winner, atom} | false)
  defp four_in_a_row(to_check) do
    to_check
    |> Enum.chunk_every(4, 1, :discard)
    |> Enum.map(&all_same/1)
  end

  @spec all_same(list(atom)) :: {:winner, atom} | false
  defp all_same(to_check) do
    first = List.first(to_check)

    if Enum.all?(to_check, &(&1 == first)) and first != :blank do
      {:winner, first}
    else
      false
    end
  end
end
