defmodule Statechart.Type.NodeName do

  alias Statechart.Type.Root

  # *** *******************************
  # *** TYPES

  @type t :: [atom | Root.t]

  # *** *******************************
  # *** CONSTRUCTORS

  # TODO remove
  def new, do: [Root.new()]

  def root, do: [Root.new()]

  # *** *******************************
  # *** REDUCERS

  def add_depth(node_name, next_local_node_name) when is_atom(next_local_node_name) do
    [next_local_node_name | node_name]
  end

  def decrease_depth([_ | node_name]), do: node_name

  # *** *******************************
  # *** CONVERTERS

  def recursive_stream(node_name) do
    Stream.unfold(node_name, fn
      :stop -> nil
      [%Root{}] -> {[%Root{}], :stop}
      [_inner | outer] = next_node_name -> {next_node_name, outer}
    end)
  end

  def parents([%Root{}]), do: recursive_stream(:stop)
  def parents([_ | node_name]), do: recursive_stream(node_name)

  def in?([_ | parent_node_name] = current_node_name, sought_node_name)
  when is_list(sought_node_name)
  and length(current_node_name) > length(sought_node_name) do
    in?(parent_node_name, sought_node_name)
  end

  def in?(current_node_name, sought_node_name)
  when is_list(sought_node_name) do
    current_node_name == sought_node_name
  end

  def in?(current_node_name, sought_node_name)
  when is_atom(sought_node_name) do
    sought_node_name in current_node_name
  end

  # TODO rename local_node_name
  def local_name([%Root{}]), do: Root.new()
  def local_name([value | _]), do: value

end
