defmodule Games.TicTacToe do
  defstruct [:board,  winner: nil, draw: false]
  alias Games.TicTacToe.{Board, ComputerPlayer}

  @type t :: %__MODULE__{
    board: map,
    winner: nil | :player | :computer,
    draw: boolean
  }

  @display_module Application.compile_env(
                    :games,
                    :tic_tac_toe_display_module,
                    Games.TicTacToe.Display
                  )

  def play() do
    @display_module.welcome()
    @display_module.instructions(nil)
    play(%__MODULE__{board: Board.new()})
  end

  def play(%__MODULE__{winner: :player}), do: @display_module.victory(nil)
  def play(%__MODULE__{winner: :computer}), do: @display_module.defeat(nil)
  def play(%__MODULE__{draw: :true}), do: @display_module.draw(nil)

  def play(%__MODULE__{} = game) do
    game
    |> show_feedback() 
    |> player_turn()
    |> win_check()
    |> draw_check()
    |> computer_turn()
    |> win_check()
    |> draw_check()
    |> play()
  end

  @spec show_feedback(t) :: t
  def show_feedback(game) do
    @display_module.display_feedback(game)
    game
  end
  
  @spec player_turn(t) :: t
  def player_turn(%__MODULE__{winner: winner} = game) when winner != nil, do: game 
  def player_turn(%__MODULE__{draw: true} = game), do: game 
  def player_turn(%__MODULE__{board: board} = game) do
    player_move = @display_module.get_user_input(game)
    {:ok, board} = Board.mark(board, player_move, :x)
    Map.put(game, :board, board)
  end

  @spec computer_turn(t) :: t
  def computer_turn(%__MODULE__{winner: winner} = game) when winner != nil, do: game 
  def computer_turn(%__MODULE__{draw: true} = game), do: game 
  def computer_turn(%__MODULE__{board: board} = game) do
    computer_move = ComputerPlayer.move(board, :perfect)
    {:ok, board} = Board.mark(board, computer_move, :o)
    Map.put(game, :board, board)
  end

  @spec win_check(t) :: t
  def win_check(%__MODULE__{winner: winner} = game) when winner != nil, do: game
  def win_check(%__MODULE__{board: board} = game) do
    case winner(board) do
      :no_winner -> game
      {true, :x} -> 
        @display_module.display_feedback(game)
        Map.put(game, :winner, :player)
      {true, :o} -> 
        @display_module.display_feedback(game)
        Map.put(game, :winner, :computer)
    end
  end

  @spec draw_check(t) :: t
  def draw_check(%__MODULE__{draw: true} = game), do: game
  def draw_check(%__MODULE__{board: board} = game) do
    if Board.fully_marked?(board) do
      @display_module.display_feedback(game)
      Map.put(game, :draw, true)
    else
      game
    end
  end

  @spec winner(struct) :: :no_winner | {true, atom}
  def winner(board) do
    with :no_winner <- row_winner(board),
         :no_winner <- col_winner(board),
         :no_winner <- diag_winner(board) do
      :no_winner
    end
  end

  def row_winner(board), do: all_same(Board.rows(board))
  def col_winner(board), do: all_same(Board.cols(board))
  def diag_winner(board), do: all_same(Board.diagonals(board))

  def all_same(groups) do
    for {_, group} <- groups, marker <- [:x, :o] do
      {Enum.all?(group, fn {_k, v} -> v == marker end), marker}
    end
    |> Enum.find(:no_winner, fn {same, _marker} -> same end)
  end
end
