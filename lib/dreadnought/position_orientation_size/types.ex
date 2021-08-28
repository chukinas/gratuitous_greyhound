defmodule Dreadnought.PositionOrientationSize.Types do

  alias Dreadnought.PositionOrientationSize.Pose
  alias Dreadnought.PositionOrientationSize.Position
  alias Dreadnought.PositionOrientationSize.Size

  defmacro __using__(_opts) do
    quote do

      @type position_key    :: :x | :y
      @type pose_key        :: :angle | position_key
      @type size_key        :: :width | :height

      @type position_map    :: %{position_key => number, optional(any) => any}
      @type pose_map        :: %{pose_key     => number, optional(any) => any}
      @type size_map        :: %{size_key     => number, optional(any) => any}
      @type pos_map         :: position_map | pose_map | size_map

      @type position_struct :: Position.t
      @type pose_struct     :: Pose.t
      @type size_struct     :: Size.t
      @type pos_struct      :: Position.t | Pose.t | Size.t

      @type pos_type        :: :position | :pose | :size
      #@type position_tuple  :: {:position,  position_map}
      #@type pose_tuple      :: {:pose,      pose_map}
      #@type size_tuple      :: {:size,      size_map}
      #@type pos_tuple       :: position_tuple | pose_tuple | size_tuple
      @type pos_tuple       :: {pos_type, pos_map}
      @type pos_keywords    :: [pos_tuple]

    end
  end

end
