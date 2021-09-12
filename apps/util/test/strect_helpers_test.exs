defmodule Util.StructHelpersTest do

  use ExUnit.Case
  #import Util.StructHelpers

  #test "Test enforced_struct" do

  #  defmodule MyStruct do
  #    use StructHelpers
  #    enforced_struct do
  #      getter_field :cool, integer, default: 42
  #    end
  #  end

  #  my_struct = %MyStruct{}
  #  assert 42 == MyStruct.cool(my_struct)

  #end

  test "test plugin" do
    alias UtilTest.MyStruct
    my_struct = %MyStruct{}
    assert 42 == MyStruct.cool(my_struct)
  end

  test "test plugin use" do
    alias UtilTest.MyGetterStruct
    my_struct = %MyGetterStruct{}
    assert 42 == MyGetterStruct.cool(my_struct)
  end

end
