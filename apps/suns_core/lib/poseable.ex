defprotocol SunsCore.Space.Poseable do

  alias SunsCore.Space.TablePose

  @spec table_pose(t) :: TablePose.t
  def table_pose(poseable)

end
