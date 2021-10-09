defmodule Statechart.Node.Moniker do

  alias Statechart.Node.LocalName.Root
  alias Statechart.Node.Moniker.Self

  defmodule Locals do
    # TYPES
    @type t :: [atom | Root.t]
    # CONSTRUCTORS
    def new(), do: [Root.new()]
    # CONVERTERS
    def contains?([_ | parent_node_name] = current_node_name, sought_node_name)
    when is_list(sought_node_name)
    and length(current_node_name) > length(sought_node_name) do
      contains?(parent_node_name, sought_node_name)
    end
    def contains?(current_node_name, sought_node_name)
    when is_list(sought_node_name) do
      current_node_name == sought_node_name
    end
    def contains?(current_node_name, sought_node_name)
    when is_atom(sought_node_name) do
      sought_node_name in current_node_name
    end
    def local_name([%Root{}]), do: Root.new()
    def local_name([value | _]), do: value
    @spec recursive_stream(t) :: any
    def recursive_stream(node_name) do
      Stream.unfold(node_name, fn
        :stop -> nil
        [%Root{}] -> {[%Root{}], :stop}
        [_inner | outer] = next_node_name -> {next_node_name, outer}
      end)
    end
    def ancestors([%Root{}]), do: recursive_stream(:stop)
    def ancestors([_ | node_name]), do: recursive_stream(node_name)
  end

  # *** *******************************
  # *** TYPES

  @type destination :: t | Self.t

  use Util.GetterStruct
  getter_struct do
    field :nested_local_names, Locals.t, default: Locals.new()
    field :depth, integer, default: 1
  end

  # *** *******************************
  # *** CONSTRUCTORS

  defp new(locals) when is_list(locals) do
    %__MODULE__{
      nested_local_names: locals,
      depth: length(locals)
    }
  end

  def root, do: %__MODULE__{}

  # *** *******************************
  # *** REDUCERS

  def down(%__MODULE__{nested_local_names: current}, local_name) when is_atom(local_name) do
    new([local_name | current])
  end

  def up(%__MODULE__{nested_local_names: [_ | locals]}) do
    new(locals)
  end

  # *** *******************************
  # *** REDUCERS (private)

  @spec common_ancestor(t, t) :: t
  defp common_ancestor(name1, name2) do
    reverse_stream_1 = name1 |> recursive_stream |> Enum.reverse
    reverse_stream_2 = name2 |> recursive_stream |> Enum.reverse
    {node_name, _} =
      Enum.zip(reverse_stream_1, reverse_stream_2)
      |> Enum.filter(fn {a, b} -> a == b end)
      |> List.last
    node_name
  end

  # *** *******************************
  # *** CONVERTERS

  def contains?(%__MODULE__{nested_local_names: locals}, sought), do: Locals.contains?(locals, sought)

  def recursive_stream(%__MODULE__{nested_local_names: locals}, min_depth \\ 0) do
    locals
    |> Locals.recursive_stream
    |> Stream.map(&new/1)
    |> Stream.take_while(& depth(&1) >= min_depth)
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

  def ancestors(%__MODULE__{nested_local_names: locals}, min_depth \\ 0) do
    locals
    |> Locals.ancestors
    |> Stream.map(&new/1)
    |> Stream.take_while(& depth(&1) >= min_depth)
  end

  def local_name(%__MODULE__{nested_local_names: locals}), do: Locals.local_name(locals)

  def to_local_name_tuple(node_name) do
    {local_name(node_name), node_name}
  end

  def depth(%__MODULE__{nested_local_names: locals}), do: Enum.count(locals)

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
      |> recursive_stream(common_depth + 1)
      |> Enum.reverse
      |> Stream.map(&{:down, &1})
    [{:start, from} | Enum.concat(up_chain, down_chain)]
  end

  def same_as?(name1, name2) do
    name1.nested_local_names == name2.nested_local_names
  end

end

# *** *********************************
# *** IMPLEMENTATIONS

alias Statechart.Node.Moniker

defimpl Inspect, for: Moniker do
  import Inspect.Algebra
  alias Statechart.Node.LocalName.Root
  require IOP
  def inspect(%Moniker{nested_local_names: locals}, opts) do
    case Enum.intersperse(locals, "/") do
      [%Root{}] ->
        IOP.color("#RootMoniker")
      [head | tail] ->
        [%Root{}, "/" | inner_locals] = Enum.reverse(tail)
        concat [
          IOP.color("#Moniker<"),
          color(Enum.join(inner_locals), :atom, opts),
          color(Atom.to_string(head), :highlight1, opts),
          IOP.color(">")
        ]
    end
  end
end
