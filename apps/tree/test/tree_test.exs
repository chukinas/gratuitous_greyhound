defmodule TreeTest do
  use ExUnit.Case
  alias Tree.Node

  describe "Tree.add_child/3" do
    test "when child is a Node" do
      tree = Tree.new()
      node = Node.new(:billy)
      fetch_spec = {:id, random_parent_id(tree)}
      new_tree = Tree.add_child(tree, node, fetch_spec)
      assert node_count(new_tree) == 2
    end
  end

  defp random_parent_id(tree) do
    tree |> Tree.nodes() |> Enum.map(&Node.id/1) |> Enum.random()
  end

  defp node_count(tree) do
    tree |> Tree.nodes() |> length
  end
end
