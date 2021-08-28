defmodule SunsCore.Event.CommandPhase.AssignCmd do

  use SunsCore.Event, :impl
  alias SunsCore.Mission.Cmd
  alias SunsCore.Mission.Helm

  # *** *******************************
  # *** TYPES

  event_struct do
    field :cmd, Cmd.t
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(player_id, %Cmd{} = cmd) do
    %__MODULE__{
      initiator: player_id,
      cmd: cmd
    }
  end

  # *** *******************************
  # *** CONVERTERS

  def all_players_assigned_cmd?(_, _), do: false

  # *** *******************************
  # *** CALLBACKS

  @impl Event
  def guard(%__MODULE__{cmd: cmd}, %Cxt{scale: scale}) do
    with :ok <- Cmd.check_all_cmd_assigned(cmd, scale),
         :ok <- Cmd.check_assigns_gte_zero(cmd) do
      :ok
    else
      {:error, _reason} = error ->
        error
    end
  end

  @impl Event
  def action(%__MODULE__{initiator: player_id, cmd: cmd}, cxt) do
    helm =
      cxt
      |> Cxt.helm_by_id(player_id)
      |> Helm.put_cmd(cmd)
    cxt
    |> Cxt.overwrite!(helm)
    |> ok
  end

  @impl Event
  def post_guard(_ev, %Cxt{helms: helms}) do
    helms
    |> Helm.Collection.all_cmd_assigned?
    |> if(do: :ok, else: :stay)
  end

end
