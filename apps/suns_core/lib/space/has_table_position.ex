defprotocol SunsCore.Mission.HasTablePosition do

  alias SunsCore.Space.TablePose
  alias SunsCore.Space.TablePosition

  @spec table_position(any) :: TablePosition.t | TablePose.t
  def table_position(item)

end
