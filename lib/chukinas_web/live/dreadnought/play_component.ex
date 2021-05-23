alias ChukinasWeb.Dreadnought.{PlayComponent}
alias Chukinas.Dreadnought.{UserSession}

defmodule PlayComponent do
  use ChukinasWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {validity, changeset} =
      UserSession.changeset(assigns.user_session, %{})
    socket =
      socket
      |> assign(valid_session?: validity == :ok)
      |> assign(changeset: changeset)
      |> assign(user_session: UserSession.apply(changeset))
    {:ok, socket}
  end

end
