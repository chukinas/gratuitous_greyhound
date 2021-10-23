defmodule SunsCore.Mission.JumpPoint do

  alias SunsCore.Mission.Battlegroup.Class
  alias SunsCore.Mission.Ship
  alias SunsCore.Mission.Object
  alias SunsCore.Space.TablePose
  alias SunsCore.Space
  alias Util.Response

  # *** *******************************
  # *** TYPES

  @type t :: Object.t

  # *** *******************************
  # *** CONSTRUCTORS

  def new(player_id, id, %TablePose{} = table_pose, turn_number) do
    Object.new_jump_point(player_id, turn_number, id: id, table_pose: table_pose)
  end

  # *** *******************************
  # *** REDUCERS

  # *** *******************************
  # *** CONVERTERS

  @spec check_ships_are_within(t, [Ship.t]) :: Response.t
  def check_ships_are_within(%Object{} = jump_point, [ship, _] = ships)
  when is_list(ships) do
    # Assumes all ships are in the same battlegroup (and hence have
    # same jump range)
    range =
      ship
      |> Ship.class_name
      |> Class.jump_range
    Space.observer_within_range_of_all_subjects(jump_point, ships, range)
    |> Response.from_bool("Not all ships are within range (#{range}) of jump point!")
  end

  # TODO add check that not w/in 10" of planetoid

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl CollisionDetection.Collidable do
    def entity(jump_point) do
      jump_point
      |> Object.table_pose
      |> CollisionDetection.Collidable.entity
    end
  end

end
