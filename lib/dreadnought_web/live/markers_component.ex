defmodule DreadnoughtWeb.MarkersComponent do

  use DreadnoughtWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <svg viewBox="0 0 30 30">
      <circle cx="50" cy="50" r="15" />
    </svg>
    """
  end

end
