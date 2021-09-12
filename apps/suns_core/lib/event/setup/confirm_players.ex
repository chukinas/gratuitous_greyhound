defmodule SunsCore.Event.Setup.ConfirmPlayers do

  use SunsCore.Event, :impl
  alias SunsCore.Mission.Snapshot, as: Cxt

  # *** *******************************
  # *** TYPES

  event_struct do
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new() do
    %__MODULE__{}
  end

  # *** *******************************
  # *** CONVERTERS

  def player_count(_, cxt) do
    cxt |> Cxt.helms |> length
  end

  def valid_player_count?(ev, cxt) do
    player_count(ev, cxt) in 1..4
  end

  # *** *******************************
  # *** CALLBACKS

  @impl Event
  def guard(ev, cxt) do
    if valid_player_count?(ev, cxt) do
      :ok
    else
      {:error, "Player count must be between 1 and 4. Currently: #{player_count(ev, cxt)}"}
    end
  end

end
