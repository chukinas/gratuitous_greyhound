defmodule Dreadnought.LinearAlgebra.Csys.Guards do

  defmacro __using__(_opts) do
    quote do
      require Dreadnought.LinearAlgebra.Csys.Guards
      import Dreadnought.LinearAlgebra.Csys.Guards
    end
  end

  defguard is_csys(csys)
    when is_map_key(csys, :orientation)
    and is_map_key(csys, :location)

end
