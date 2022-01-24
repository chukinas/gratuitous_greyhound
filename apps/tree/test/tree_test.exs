defmodule TreeTest do
  use ExUnit.Case
  alias Tree.Node

  describe "Tree.add_child/3" do
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
  end

  defp random_parent_id(tree) do
    tree |> Tree.nodes() |> Enum.map(&Node.id/1) |> Enum.random()
  end

  defp node_count(tree) do
    tree |> Tree.nodes() |> length
  end
end
