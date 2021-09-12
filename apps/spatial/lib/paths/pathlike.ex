defprotocol Dreadnought.Paths.PathLike do
  def pose_start(path)
  def pose_end(path)
  def len(path)
  def exceeds_angle(path, angle)
  def deceeds_angle(path, angle)
end
