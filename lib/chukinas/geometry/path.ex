defprotocol Chukinas.Geometry.Path do
  def pose_start(path)
  def pose_end(path)
  def pose_at(path)
  def len(path)
end
