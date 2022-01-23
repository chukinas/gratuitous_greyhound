defmodule Tree.Node do
  use Util.GetterStruct

  @type id :: pos_integer
  @type lft_or_rgt :: non_neg_integer
  @type fetch_spec ::
          {:lft, lft_or_rgt()}
          | {:id, id()}
          | {:name, atom}

  getter_struct enforce: false do
    field :id, id
    field :name, atom, enforce: true
    field :lft, lft_or_rgt

    field :rgt, lft_or_rgt
  end

  #####################################
  # CONSTRUCTORS

  def root() do
    %__MODULE__{
      id: 0,
      name: :root,
      lft: 0,
      rgt: 1
    }
  end

  def new(name) when is_atom(name), do: %__MODULE__{name: name}

  #####################################
  # REDUCERS

  @doc """
  Used when inserted other nodes into a tree.

  Should only be used by `Tree`
  """
  def maybe_update_position(%__MODULE__{} = node, min_value, addend) do
    Enum.reduce([:lft, :rgt], node, fn key, node ->
      if Map.fetch!(node, key) >= min_value do
        Map.update!(node, key, &(&1 + addend))
      else
        node
      end
    end)
  end

  #####################################
  # CONVERTERS

  @spec match?(t, fetch_spec) :: boolean
  def match?(node, fetch_spec)
  def match?(%__MODULE__{id: value}, {:id, value}), do: true
  def match?(%__MODULE__{name: value}, {:name, value}), do: true
  def match?(%__MODULE__{lft: value}, {:lft, value}), do: true
  def match?(_, _), do: false
end
