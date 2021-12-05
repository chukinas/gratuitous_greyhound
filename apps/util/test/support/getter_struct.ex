defmodule Util.TestSupport.GetterStruct do

  use Util.GetterStruct

  getter_struct do
    field :cool, integer
  end

  def new(value) do
    %__MODULE__{cool: value}
  end

end


defmodule Util.TestSupport.GetterStructWithOpts do

  use Util.GetterStruct

  getter_struct enforce: false do
    field :cool, integer, default: 42
  end

  def new do
    %__MODULE__{}
  end

end
