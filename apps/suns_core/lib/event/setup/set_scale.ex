defmodule SunsCore.Event.Setup.SetScale do

  use SunsCore.Event, :impl

  # *** *******************************
  # *** TYPES

  event_struct do
    field :scale, pos_integer()
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(scale) when scale in 1..10 do
    %__MODULE__{scale: scale}
  end

  @impl Event
  def action(%__MODULE__{scale: scale}, snapshot) do
    %S{snapshot | scale: scale}
    |> ok
  end

end
