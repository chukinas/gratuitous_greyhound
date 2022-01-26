defmodule TreeTest do
  use ExUnit.Case
  use ExUnitProperties
  alias Tree.Node

  # properties:
  #   unique name, id, lft, rgt
  #   nodes are always sorted in ASC lft
  #   when inserted a node, I know its parent id (b/c I randomly picked it)
  #     so I can look up a node by that id and compare it to the node's parent
  #     they should be the same.
  # Test for what happens when duplicate name is attempted to be inserted

  setup_all do
    empty_tree = Tree.new()
    starting_max_parent_id = Tree.max_node_id(empty_tree)

    # [atom] :: [{Node.t(), integer}]
    nodes_with_parent_ids_generator =
      map(uniq_list_of(atom(:alphanumeric)), fn names ->
        names
        |> Stream.map(&Node.new/1)
        |> Stream.with_index(starting_max_parent_id)
        |> Enum.map(fn {node, max_parent_id} -> {node, Enum.random(0..max_parent_id)} end)
      end)

    build_tree = fn nodes_and_parent_ids ->
      Enum.reduce(nodes_and_parent_ids, empty_tree, fn {node, parent_id}, tree ->
        Tree.add_child(tree, node, parent_id)
      end)
    end

    [
      tree_generator: map(nodes_with_parent_ids_generator, build_tree)
    ]
  end

  property "Nodes are stored in ascending lft order", %{tree_generator: generator} do
    check all tree <- generator do
      node_lft_values = Tree.nodes(tree |> IO.inspect(), mapper: &Node.lft/1)
      assert node_lft_values == Enum.sort(node_lft_values)
    end
  end
end
