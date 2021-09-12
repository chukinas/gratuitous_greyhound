defmodule SunsCore.Event.Setup.AddPlayer do

  use SunsCore.Event, :impl
  alias SunsCore.Mission.Helm
  alias SunsCore.Mission.Snapshot, as: C

  # *** *******************************
  # *** TYPES

  event_struct do
    #field :scale, pos_integer()
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new() do
    %__MODULE__{}
  end

  # *** *******************************
  # *** CONVERTERS

  def helm(_, context) do
    context
    |> C.next_id(:helms)
    |> Helm.new
  end

  # *** *******************************
  # *** CALLBACKS

  @impl Event
  def action(event, context) do
    context
    |> C.put_new(helm(event, context))
    |> ok
  end

end
