defmodule SunsCore.Mission.Objective.Builder do

  alias SunsCore.Mission.Contract
  alias SunsCore.Space.TablePosition

  defmacro __using__(_opts) do
    quote do
      alias SunsCore.Mission.Objective
      import unquote(__MODULE__), only: [objective_struct: 1, default_objective_struct: 0]
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro objective_struct(opts) do
    quote do
      use TypedStruct
      alias SunsCore.Space.TablePosition
      typedstruct enforce: true do
        field :id, pos_integer, default: 0
        field :contract_type, Contract.type
        field :table_position, TablePosition.t
        unquote(opts[:do])
      end
    end
  end

  defmacro default_objective_struct do
    quote do
      objective_struct do
      end
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      alias __MODULE__, as: ThisObjective
      defimpl SunsCore.Mission.Objective do
        def contract_type(%ThisObjective{contract_type: value}), do: value
        def table_position(%ThisObjective{table_position: value}), do: value
        def id(%ThisObjective{id: value}), do: value
        def set_id(obj, id), do: %ThisObjective{obj | id: id}
      end
    end
  end
end