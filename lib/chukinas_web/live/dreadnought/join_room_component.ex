alias ChukinasWeb.Dreadnought.{JoinRoomComponent}
alias Chukinas.Dreadnought.{UserSession}

defmodule JoinRoomComponent do
  use ChukinasWeb, :live_component
  use Phoenix.HTML
  import ChukinasWeb.ErrorHelpers

  #use Ecto.Schema
  # http://blog.plataformatec.com.br/2016/05/ectos-insert_all-and-schemaless-queries/

  @impl true
  def handle_event("validate", %{"user_session" => params}, socket) do
    IOP.inspect params, "join room validate"
    changeset =
      params
      |> UserSession.changeset
      |> Map.put(:action, :insert)
      |> IOP.inspect
      #|> apply_changes
    #case UserSession.changeset(%UserSession{}, params) do
    #  %{valid?: true} = changeset ->
    #    user_session =
    #      changeset
    #      |> apply_changes
    #    {:ok, user_session}
    #  changeset ->
    #    {:error, changeset}
    #end
    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user_session" => params}, socket) do
    changeset =
      params
      |> UserSession.changeset
      |> IOP.inspect
    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(changeset: UserSession.empty())
      |> IOP.inspect("join room update")
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    #ChukinasWeb.DreadnoughtView.render("component_join_room.html", assigns)
    ~L"""
    <%= f = form_for @changeset, "#", phx_change: :validate, phx_submit: :save, phx_target: @myself %>
      <%= label f, :username %>
      <%= text_input f, :username %>
      <%= error_tag f, :username %>

      <%= label f, :room %>
      <%= text_input f, :room %>
      <%= error_tag f, :room %>

      <%= submit "Save" %>
    </form>
    """
  end
end