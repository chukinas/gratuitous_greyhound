defmodule Spatial.LinearAlgebra.Csys.Guards do

  defmacro __using__(_opts) do
    quote do
      require Spatial.LinearAlgebra.Csys.Guards
      import Spatial.LinearAlgebra.Csys.Guards
    end
  end

  defguard is_csys(csys)
    when is_map_key(csys, :orientation)
    and is_map_key(csys, :location)

end
