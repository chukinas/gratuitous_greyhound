defmodule Switch do
  use GenStateMachine

  # Client

  def start_link() do
    GenStateMachine.start_link(Switch, {:off, 0}, name: MySwitch)
  end

  def flip() do
    GenStateMachine.cast(MySwitch, :flip)
  end

  def get_count() do
    GenStateMachine.call(MySwitch, :get_count)
  end

  # Server (callbacks)

  def handle_event(:cast, :flip, :off, data) do
    {:next_state, :on, data + 1}
  end

  def handle_event(:cast, :flip, :on, data) do
    {:next_state, :off, data}
  end

  def handle_event({:call, from}, :get_count, state, data) do
    {:next_state, state, data, [{:reply, from, data}]}
  end

  def handle_event(event_type, event_content, state, data) do
    # Call the default implementation from GenStateMachine
    super(event_type, event_content, state, data)
  end
end
