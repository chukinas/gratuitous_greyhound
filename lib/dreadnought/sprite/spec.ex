defmodule Dreadnought.Sprite.Spec do

  @type t :: nil

  #@module __MODULE__
  #defmacro __using__(_opts) do
  #  quote do
  #    require unquote(@module)
  #    import unquote(@module)
  #    # TODO DRY
  #    @type mission_spec :: {mission_builder_module :: atom, mission_name :: String.t}
  #  end
  #end

  #defguard is_mission_spec(mission_spec)
  #when is_tuple(mission_spec)
  #and tuple_size(mission_spec) === 2
  #and elem(mission_spec, 0) |> is_atom # Module implementing Mission.Builder behaviour
  #and elem(mission_spec, 1) |> is_binary # mission_name

  ## TODO write macro that pulls the local module name
  #def new_mission_spec(module, mission_name) do
  #  {module, mission_name}
  #end

  #def name_from_mission_spec({_module, name} = mission_spec)
  #when is_mission_spec(mission_spec) do
  #  name
  #end

end
