defmodule Statechart.Node.Moniker do

  # TODO make the various name definitions clear
  #   Moniker: a struct that uniquely, fully-qualifies a node's name
  #   NameChain: a list of local names that uniquely identifies a node. Tail name is Root
  #   Name: an individual link in the name chain. Either an atom or Root
  #   HeadName: the latest Name in the NameChain. May or may not be unique


  # TODO rename Node.Name.Root
  alias Statechart.Node.LocalName.External
  alias Statechart.Node.LocalName.Root
  alias Statechart.Node.Moniker.Self
  alias Statechart.Node.Moniker.NameChain

  # *** *******************************
  # *** TYPES

  @type destination :: t | Self.t

  use Util.GetterStruct
  getter_struct do
    field :name_chain, NameChain.t
    field :depth, integer, default: 1
  end

  # *** *******************************
  # *** CONSTRUCTORS

  defp new(name_chain) when is_list(name_chain) do
    %__MODULE__{
      name_chain: name_chain,
      depth: length(name_chain)
    }
  end

  def new_root do
    new [Root.new()]
  end

  def new_external(nil) do
    new [External.new(), Root.new()]
  end

  def new_external(name) do
    new [name, External.new(), Root.new()]
  end

  # *** *******************************
  # *** REDUCERS

  def down(%__MODULE__{name_chain: current}, name) when is_atom(name) do
    new([name | current])
  end

  def up(%__MODULE__{name_chain: [_ | parent_name_chain]}) do
    new(parent_name_chain)
  end

  # *** *******************************
  # *** REDUCERS (private)

  @spec common_ancestor(t, t) :: t
  defp common_ancestor(name1, name2) do
    reverse_stream_1 = name1 |> unfold_up |> Enum.reverse
    reverse_stream_2 = name2 |> unfold_up |> Enum.reverse
    {node_name, _} =
      Enum.zip(reverse_stream_1, reverse_stream_2)
      |> Enum.filter(fn {a, b} -> a == b end)
      |> List.last
    node_name
  end

  # *** *******************************
  # *** CONVERTERS

  def contains?(%__MODULE__{name_chain: [_ | parent_name_chain]}, sought_name_chain)
  when is_list(sought_name_chain)
  and length(parent_name_chain) > length(sought_name_chain) do
    contains?(parent_name_chain, sought_name_chain)
  end

  def contains?(%__MODULE__{name_chain: name_chain}, sought_name_chain)
  when is_list(sought_name_chain) do
    name_chain == sought_name_chain
  end

  def contains?(%__MODULE__{name_chain: name_chain}, sought_name)
  when is_atom(sought_name) do
    sought_name in name_chain
  end

  def parent(%__MODULE__{} = moniker) do
    moniker
    |> ancestors
    |> Enum.take(1)
    |> case do
      [] -> raise "#{moniker} has no parent!"
      [parent] -> parent
    end
  end

  # TODO rename name (or nickname?)
  def local_name(%__MODULE__{name_chain: [value | _]}), do: value

  def local_name_as_atom(moniker) do
    case moniker |> local_name do
      %Root{} = root -> Root.name_as_atom(root)
      name when is_atom(name) -> name
    end
  end

  def depth(%__MODULE__{name_chain: name_chain}), do: Enum.count(name_chain)

  @spec transition_steps(t, t) :: [{:up | :down, t}]
  def transition_steps(from, to) do
    ancestor = from |> common_ancestor(to)
    common_depth = depth(ancestor)
    up_chain =
      from
      |> ancestors(common_depth)
      |> Stream.map(&{:up, &1})
    down_chain =
      to
      |> unfold_up(common_depth + 1)
      |> Enum.reverse
      |> Stream.map(&{:down, &1})
    [{:start, from} | Enum.concat(up_chain, down_chain)]
  end

  def same_as?(name1, name2) do
    name1.name_chain == name2.name_chain
  end

  def compare(moniker1, moniker2) do
    case {depth(moniker1), depth(moniker2)} do
      {depth1, depth2} when depth1 > depth2 -> :gt
      {depth1, depth2} when depth1 < depth2 -> :lt
      _ -> :eq
    end
  end

  def unfold_up(%__MODULE__{name_chain: orig_name_chain}, min_depth \\ 0) do
    orig_name_chain
    |> Stream.unfold(fn
        [] ->
          nil
        [_name | parent_name_chain] = name_chain ->
          {name_chain, parent_name_chain}
      end)
    |> Stream.map(&new/1)
    |> Stream.take_while(& depth(&1) >= min_depth)
  end

  @spec ancestors(t) :: [t]
  def ancestors(moniker, min_depth \\ 0) do
    moniker
    |> unfold_up(min_depth)
    |> Enum.drop(1)
  end

  @doc """
  #Moniker<foo/bar> -> [:bar, :foo, :root]
  """
  def ancestors_as_atom_list(moniker) do
    moniker
    |> ancestors
    |> Enum.map(&local_name_as_atom/1)
  end

end

# *** *********************************
# *** IMPLEMENTATIONS

alias Statechart.Node.Moniker

defimpl Inspect, for: Moniker do
  import Inspect.Algebra
  alias Statechart.Node.LocalName.External
  alias Statechart.Node.LocalName.Root
  require IOP
  def inspect(%Moniker{name_chain: name_chain}, opts) do
    case name_chain do
      [%Root{}] ->
        IOP.color("#RootMoniker")
      [%External{}, %Root{}] ->
        IOP.color("#ExternalMoniker")
      [name, %External{}, %Root{}] ->
        concat [
          IOP.color("#ExternalMoniker<"),
          color(Atom.to_string(name), :highlight1, opts),
          IOP.color(">")
        ]
      [nickname | parent_name_chain] ->
        [%Root{} | names] = Enum.reverse(parent_name_chain)
        names =
          if length(names) == 0 do
            ""
          else
            names
            |> Enum.intersperse("/")
            |> List.insert_at(-1, "/")
            |> Enum.join
          end
        concat [
          IOP.color("#Moniker<"),
          color(names, :atom, opts),
          color(Atom.to_string(nickname), :highlight1, opts),
          IOP.color(">")
        ]
    end
  end
end
