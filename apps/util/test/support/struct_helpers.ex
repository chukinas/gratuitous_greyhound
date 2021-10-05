defmodule UtilTest.MyStruct do
  use TypedStruct
  typedstruct do
    plugin Util.GetterStructPlugin
    field :cool, integer, default: 42
  end
end

defmodule UtilTest.MyGetterStruct do
  use Util.GetterStruct
  getter_struct do
    field :cool, integer, default: 42
  end
end
