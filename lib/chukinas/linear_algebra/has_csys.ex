alias Chukinas.LinearAlgebra.HasCsys
alias Chukinas.Geometry.Pose

defprotocol Chukinas.LinearAlgebra.HasCsys do
  def get_csys(term)
  def get_angle(term)
end

#defimpl HasCsys, for: Pose do
#  def get_csys(term)
#  def get_angle(%{angle: value}), do: value
#end
