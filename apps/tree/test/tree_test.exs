defmodule TreeTest do
  use ExUnit.Case
  use ExUnitProperties
  alias Tree.Node

  test "when child is a Node" do
    # child_name_generator = StreamData.atom(:alphanumeric)

    tree = Tree.new()
    child_name = :billy
    node = Node.new(child_name)
    child_fetch_spec = {:name, child_name}
    parent_fetch_spec = {:id, parent_id = random_parent_id(tree)}
    # TODO add bang!
    new_tree = Tree.add_child(tree, node, parent_fetch_spec)
    {:ok, new_node} = Tree.fetch(new_tree, child_fetch_spec)
    assert node_count(new_tree) == 2
    assert Tree.map_nodes(new_tree, &Node.lft/1) == [0, 1]
    assert Tree.fetch_parent_of!(new_tree, new_node).id == parent_id
    # properties:
    #   unique name, id, lft, rgt
    #   nodes are always sorted in ASC lft
    #   when inserted a node, I know its parent id (b/c I randomly picked it)
    #     so I can look up a node by that id and compare it to the node's parent
    #     they should be the same.
  end

  property "Tree's nodes are always stored in ascending order by :lft" do
    empty_tree = Tree.new()
    starting_max_parent_id = Tree.max_node_id(empty_tree)
    # get list of atoms (for the Node names)
    # create a Tree
    # get the max id.
    # map the list of atoms to {current_max_id, Node} tuples. The max id increases by one for each
    # map this tuple to {random_parent_id, Node} tuples. The max id increases by one for each
    # Insert each node into the tree using the rand parent id
    # Get the nodes and map them to lft
    # Assert that they list starts at zero and increments by one
    #   insert the node into the tree
    #
    check all(node_names <- list_of(atom(:alphanumeric))) do
      nodes_with_parent_ids =
        node_names
        |> Stream.uniq()
        |> Stream.map(&Node.new/1)
        |> Stream.with_index(starting_max_parent_id)
        |> Enum.map(fn {node, max_parent_id} -> {node, Enum.random(0..max_parent_id)} end)

      tree =
        Enum.reduce(nodes_with_parent_ids, empty_tree, fn {node, parent_id}, tree ->
          Tree.add_child(tree, node, parent_id)
        end)
        |> IO.inspect()

      node_lft_values = Tree.nodes(tree, mapper: &Node.lft/1)
      assert node_lft_values == Enum.sort(node_lft_values)
    end
  end

  defp random_parent_id(tree) do
    tree |> Tree.nodes() |> Enum.map(&Node.id/1) |> Enum.random()
  end

  defp node_count(tree) do
    tree |> Tree.nodes() |> length
  end
end

# Test for what happens when duplicate name is attempted to be inserted
