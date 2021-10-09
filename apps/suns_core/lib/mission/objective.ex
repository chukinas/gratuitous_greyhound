defprotocol SunsCore.Mission.Objective do

  alias SunsCore.Mission.Contract

  @spec contract_type(t) :: Contract.t
  def contract_type(objective)

  def table_position(objective)

  def id(objective)

  def set_id(objective, id)

end
