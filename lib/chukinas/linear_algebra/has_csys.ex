# TODO Is this actually of any use? I see it implemented here and there, but the functions arn't called?
alias Chukinas.LinearAlgebra.HasCsys

defprotocol Chukinas.LinearAlgebra.HasCsys do
  def get_csys(term)
  def get_angle(term)
end
