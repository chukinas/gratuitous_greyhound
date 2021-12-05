defmodule Util.GetterStructTest do

  use ExUnit.Case

  test "enforced getter struct" do
    alias Util.TestSupport.GetterStruct, as: MyGetterStruct
    assert 42 == MyGetterStruct.new(42) |> MyGetterStruct.cool
  end

  test "non-enforced getter struct" do
    alias Util.TestSupport.GetterStructWithOpts
    assert 42 == GetterStructWithOpts.new |> GetterStructWithOpts.cool
  end

end
