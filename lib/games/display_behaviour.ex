defmodule Games.Display.Behaviour do
  @callback  welcome() :: :ok
  @callback  instructions(instruction_config :: term) :: :ok
  @callback  display_feedback(feedback_config :: term) :: :ok
  @callback  get_user_input(user_message_config :: term) :: term
  @callback  victory() :: nil
  @callback  defeat(defeat_message_config :: term) :: nil
  @optional_callbacks defeat: 1
end