defmodule Chukinas.Skies.Game.Location do

  alias Chukinas.Skies.Game.{Box, Spaces}

  @type t :: Box.id() | Spaces.id()

  def to_friendly_string({_, _} = location) do
    Spaces.to_friendly_string(location)
  end
  def to_friendly_string(location) do
    Box.to_friendly_string(location)
  end

end

# TODO initial unselect crashes
# TODO try https://github.com/keathley/norm
