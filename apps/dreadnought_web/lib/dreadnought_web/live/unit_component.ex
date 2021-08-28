defmodule DreadnoughtWeb.UnitComponent do

    use DreadnoughtWeb, :live_component
  alias Dreadnought.Svg
  alias DreadnoughtWeb.SpriteComponent

  # *** *******************************
  # *** CALLBACKS

  @impl true
  def render(assigns) do
    ~L"""
    <svg <%= _attrs_string(@unit) %> >
      <%= SpriteComponent.render_use(@unit.sprite_spec) %>
      <%= for t <- @unit.turrets do %>
        <%= live_component(DreadnoughtWeb.TurretComponent, turret: t, unit_id: @unit.id) %>
      <% end %>
      <ul
        id="unit-<%= @unit.id %>-turn-<%= @turn_number %>-events"
        class="hidden"
        phx-hook="UnitEvents"
        data-unit-id="<%= @unit.id %>"
      >
        <%= for event <- @unit.events do %>
          <%= DreadnoughtWeb.UnitView.unit_event(event) %>
        <% end %>
      </ul>
    </svg>
    """
  end

# *** *******************************
  # *** UNIT CONVERTERS

  def _attrs_string(unit) do
    unit
    |> Svg.pose_to_attrs
    |> Keyword.merge(
      "data-unit-id": unit.id,
      id: "unit-#{unit.id}",
      overflow: "visible",
      viewBox: "0 0 10 10",
      width: 10,
      height: 10
    )
    |> DreadnoughtWeb.Shared.attrs
  end

end

# TODO move to separate file
defmodule DreadnoughtWeb.TurretComponent do

    use DreadnoughtWeb, :live_component
  alias Dreadnought.Core.Turret
  alias Dreadnought.Svg
  alias DreadnoughtWeb.SpriteComponent

  # *** *******************************
  # *** CALLBACKS

  @impl true
  def render(assigns) do
    ~L"""
    <svg <%= _attrs_string(@turret, @unit_id) %> >
      <%= SpriteComponent.render_use(@turret.sprite_spec) %>
    </svg>
    """
  end

  # *** *******************************
  # *** TURRET CONVERTERS

  def _attrs_string(%Turret{} = turret, unit_id) do
    turret
    |> Svg.pose_to_attrs
    |> Keyword.put(:id, "unit-#{unit_id}-mount-#{turret.id}")
    |> Keyword.put(:overflow, "visible")
    |> DreadnoughtWeb.Shared.attrs
  end

end
