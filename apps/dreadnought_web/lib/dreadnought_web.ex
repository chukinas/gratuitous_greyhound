defmodule DreadnoughtWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use DreadnoughtWeb, :controller
      use DreadnoughtWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: DreadnoughtWeb

      import Plug.Conn
      alias DreadnoughtWeb.Router.Helpers, as: Routes
    end
  end

  def base_view do
    quote do
      use Phoenix.View,
        root: "lib/dreadnought_web/templates",
        namespace: DreadnoughtWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def view do
    quote do
      unquote(base_view())
      unquote(my_custom_view_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {DreadnoughtWeb.LayoutView, "live.html"}

      unquote(view_helpers())
      unquote(my_custom_view_helpers())
      unquote(genserver_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
      unquote(my_custom_view_helpers())
      unquote(genserver_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView helpers (live_render, live_component, live_patch, etc)
      import Phoenix.LiveView.Helpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import DreadnoughtWeb.ErrorHelpers
      alias DreadnoughtWeb.Router.Helpers, as: Routes
    end
  end

  defp genserver_helpers do
    quote do
      defp live_action(socket), do: socket.assigns.live_action
      defp live_action?(socket, live_action), do: socket.assigns.live_action == live_action
      defp ok(socket), do: {:ok, socket}
      defp noreply(socket), do: {:noreply, socket}
    end
  end

  defp my_custom_view_helpers do
    quote do
      use DreadnoughtWeb.ComponentView
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

end
