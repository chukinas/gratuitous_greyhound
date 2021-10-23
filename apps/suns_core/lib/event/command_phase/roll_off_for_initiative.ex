defmodule SunsCore.Event.CommandPhase.RollOffForInitiative do

  use SunsCore.Event, :impl
  alias SunsCore.RandomNumberGenerator, as: NumGen
  alias SunsCore.Mission.Helm
  alias SunsCore.Mission.PlayerOrderTracker

  # *** *******************************
  # *** TYPES

  event_struct do
    field :rand_num_gen, NumGen.t, default: NumGen.new()
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new, do: %__MODULE__{}

  # *** *******************************
  # *** CONVERTERS

  def all_players_assigned_cmd?(_, _), do: false

  # *** *******************************
  # *** CALLBACKS

  @impl Event
  def guard(_ev, cxt) do
    if Cxt.player_count(cxt) in 1..4 do
      :ok
    else
      {:error, "Player count must be in range 1 to 4"}
    end
  end

  @impl Event
  def action(%__MODULE__{rand_num_gen: _num_gen}, %Cxt{helms: helms} = cxt) do
    #player_count = Enum.count(helms)
    tracker = PlayerOrderTracker.new(helms, 1) # TODO implement
    helms = Helm.Collection.clear_cmd_initiative(helms)
    cxt
    |> Cxt.overwrite!(helms)
    |> Cxt.set(tracker)
  end

end
