defmodule SunsCore.TestSupport.Setup do

  use Spatial, :rect
  use SunsCore.Event.Setup
  alias SunsCore.Event.Setup
  alias SunsCore.Event.Setup.AddObjective
  alias SunsCore.Machine
  alias SunsCore.Space.TablePose
  alias SunsCore.Mission.Object
  alias SunsCore.TestSupport.Helpers

  def setup do
    new_mission()
    |> add_player
    |> confirm_players
    |> set_scale
    |> add_table
    |> add_table
    |> add_first_facility
    |> add_second_facility
  end

  def new_mission() do
    Machine.new()
  end

  def add_player(machine) do
    AddPlayer.new()
    |> Helpers.apply_transition(machine)
  end

  def confirm_players(machine) do
    ConfirmPlayers.new()
    |> Helpers.apply_transition(machine)
  end

  def set_scale(machine) do
    SetScale.new(2)
    |> Helpers.apply_transition(machine)
  end

  def add_table(machine) do
    Rect.from_size(36, 48)
    |> Setup.AddTable.new
    |> Helpers.apply_transition(machine)
  end

  def add_first_facility(machine) do
    _add_facility machine, TablePose.new(1, 18, 24)
  end

  def add_second_facility(machine) do
    # TODO need to check that table exists?
    _add_facility machine, TablePose.new(2, 18, 24)
  end

  defp _add_facility(machine, pose) do
    Object.new_facility(2, table_pose: pose, contract_type: :spades)
    |> AddObjective.new
    |> Helpers.apply_transition(machine)
  end

end
