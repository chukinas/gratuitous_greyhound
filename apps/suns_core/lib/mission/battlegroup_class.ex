defmodule SunsCore.Mission.Battlegroup.Class do

  alias SunsCore.Mission.Battlegroup.ClassSpec
  alias SunsCore.Mission.Weapon

  @type t :: ClassSpec.t
  @type symbol :: atom # e.g. recon_wing, gunship, etc

  types = [
    #   NAME                COST  MASS  THRUST  SILHOUETTE  SHIELDS PRIMARYWEAPONS  AUXILIARYWEAPONS
    ~w/ recon_wing           1    0     10       2          0       light_blasters  NA            /,
    ~w/ fighter_wing         2    0      6       3          0       NA              auto_blasters /,
    ~w/ bomber_wing          3    0      4       3          0       torpedoes       NA            /,
    ~w/ light_utility_ship   1    1      4       1          1       light_blasters  NA            /,
    ~w/ gunship              3    1      6       4          1       blasters        blasters      /,
    ~w/ corvette             5    2     10       5          2       turbo_blasters  blasters      /,
    ~w/ medium_utility_ship  2    2      4       5          3       mining_laser    NA            /,
    ~w/ monitor             10    2      3       5          3       heavy_railguns  NA            /,
    ~w/ frigate              7    2      4       6          4       light_railguns  turbo_blasters/,
    ~w/ destroyer           12    3      3       6          3       cruise_missiles turbo_blasters/,
    ~w/ carrier             15    3      3       7          5       NA              NA            /,
    ~w/ cruiser             30    3      3       8          6       macro_beam      defense_grid  /,
    ~w/ battleship          40    3      2      10          5       planet_smasher  defense_grid  /
  ]

  [example_class | _] = classes =
    for [name | tail] <- types do
      name = String.to_atom(name)
      {numbers, weapons} = Enum.split(tail, 5)
      [cost, mass, thrust, silhouette, shields] = Enum.map(numbers, &String.to_integer/1)
      [primary, auxiliary] =
        Enum.map(weapons, fn
          "NA" -> nil
          string -> String.to_atom(string)
        end)
      %ClassSpec{
        name: name,
        cost: cost,
        mass: mass,
        thrust: thrust,
        silhouette: silhouette,
        shields: shields,
        primary_weapons: primary,
        auxiliary_weapons: auxiliary
      }
    end

  for class <- classes do
    def get_spec(unquote(class.name)) do
      unquote(Macro.escape(class))
    end
  end

  fields =
    example_class
    |> Map.drop([:name])
    |> Map.keys

  for key <- fields do
    def unquote(key)(class_name) when is_atom(class_name) do
      get_spec(class_name)
      |> Map.fetch!(unquote(key))
    end
    #def unquote(key)(%ClassSpec{name: class_name}) do
    #  unquote(key)(class_name)
    #end
  end

  def jump_range(class) do
    6 - mass(class)
  end

  @spec weapon_system_symbol(symbol, Weapon.type) :: Weapon.spec
  def weapon_system_symbol(class_symbol, weapon_type) do
    case weapon_type do
      :primary -> primary_weapons(class_symbol)
      :aux -> auxiliary_weapons(class_symbol)
    end
  end

  def weapon_spec(class_symbol, weapon_type) do
    weapon_system_symbol(class_symbol, weapon_type)
  end

end
