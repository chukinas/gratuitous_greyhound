defmodule SunsCore.Mission.Object do

  alias SunsCore.Mission.Weapon, as: Weapon
  alias SunsCore.Space
  alias SunsCore.Mission.Contract
  alias SunsCore.Mission.Scale

  # *** *******************************
  # *** TYPES

  @type player_id :: integer

  use Util.GetterStruct
  getter_struct do
    # TODO enforce?
    field :description, any
    field :id, integer, enforce: false
    field :silhouette, integer, default: 0
    # TODO make a controller module/type
    # where I document that id=0 means the game controls the thing
    field :controller, 0..4, default: 0
    # TODO rename :weapon_spec or :weapon_symbol?
    field :weapon_system_symbol, Weapon.spec, enforce: false
    field :table_pose, Space.table_pose | nil, enforce: false
    # TODO ?
    field :contract_type, Contract.type, enforce: false
    field :move, pos_integer, default: 0
    field :shields, pos_integer, default: 0
    field :mass, pos_integer, default: 0
    # TODO is non-zero, measurments are done from edge
    field :diameter, pos_integer, default: 0
    field :dangerous_space, boolean, default: false
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new_asteroid(opts \\ []) do
    %__MODULE__{
      description: :asteroid,
      id: opts[:id],
      mass: 2,
      silhouette: 9,
      dangerous_space: true,
      table_pose: opts[:table_pose],
      diameter: opts[:diameter] || Enum.random(1..3),
      contract_type: opts[:contract_type]
    }
  end

  def new_planetoid(opts \\ []) do
    %__MODULE__{
      description: :planetoid,
      id: opts[:id],
      dangerous_space: true,
      table_pose: opts[:table_pose],
      diameter: opts[:diameter] || Enum.random(4..12),
      contract_type: opts[:contract_type]
    }
  end

  def new_comsat(opts \\ []) do
    # TODO not allowed to touch another object
    %__MODULE__{
      description: :comsat,
      id: opts[:id],
      table_pose: opts[:table_pose],
      contract_type: opts[:contract_type]
    }
  end

  def new_facility(scale, opts \\ []) do
    %__MODULE__{
      description: :facility,
      id: opts[:id],
      silhouette: scale,
      shields: Scale.divide_by(scale, 2),
      mass: opts[:mass] || Scale.divide_by(scale, 3),
      weapon_system_symbol: {:laser_turrets, scale},
      table_pose: opts[:table_pose],
      contract_type: opts[:contract_type]
    }
  end

  def new_jump_point(controller, turn_number, opts \\ []) do
    %__MODULE__{
      description: {:jump_point, turn_number},
      id: opts[:id],
      controller: controller,
      table_pose: opts[:table_pose],
      mass: 3,
      silhouette: 5,
      shields: 2
    }
  end

  # *** *******************************
  # *** REDUCERS

  def set_id(obj, id), do: %__MODULE__{obj | id: id}

  # *** *******************************
  # *** CONVERTERS

  def weapon_spec(object) do
    object
    |> weapon_system_symbol
  end

  def max_attack_dice(%__MODULE__{} = object) do
    object
    |> weapon_system_symbol
    |> Weapon.die_count
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl SunsCore.Space.Poseable do
    alias SunsCore.Mission.Object
    defdelegate table_pose(object), to: Object
  end

  defimpl SunsCore.Mission.Attack.Subject do

    alias SunsCore.Mission.Object
    alias SunsCore.Mission.Weapon
    alias SunsCore.Space.Poseable

    defdelegate silhouette(object), to: Object

    def controller(object) do
      object.controller
    end

    # TODO is this really needed?
    def individuals(%Object{} = object), do: [Poseable.table_pose(object)]

    def max_attack_dice(object, _weapon_type) do
      Object.max_attack_dice(object)
    end

    def weapon_range(object, _weapon_type) do
      object
      |> Object.weapon_spec
      |> Weapon.range
    end

    def weapon_arc(_object, _weapon_type), do: 360

  end

end
