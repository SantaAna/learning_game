defmodule Games.Display.Behaviour do
  @callback  welcome() :: :ok
  @callback  instructions(instruction_config :: term) :: :ok
  @callback  display_feedback(feedback_config :: term) :: :ok
  @callback  get_user_input(user_message_config :: term) :: term
  @callback  victory(map()) :: :ok
  @callback  defeat(defeat_message_config :: term) :: nil
  @callback  draw(draw_message_config :: term) :: :ok
  @optional_callbacks defeat: 1, draw: 1
end
