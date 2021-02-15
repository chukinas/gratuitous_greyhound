alias Chukinas.Geometry.{PathLike}

defprotocol PathLike do
  def pose_start(path)
  def pose_end(path)
  def len(path)

  @doc """
  Returns a map describing the smallest rectangle that fully bounds the path.
  The x,y coordinates describe the corner closest to the origin.
  `width` and `height` describe the size of the box.
  """
  def get_bounding_rect(path)
end
