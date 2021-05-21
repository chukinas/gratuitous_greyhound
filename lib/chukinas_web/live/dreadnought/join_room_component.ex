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

  # TODO put the aria and placeholder stuff back in
  @impl true
  def render(assigns) do
    ~L"""
    <%= f = form_for @changeset, "#", phx_change: :validate, phx_submit: :save, phx_target: @myself %>
      <%= for field <- [:username, :room] do %>
        <div>
          <%= label f, field, label_class() %>
          <div class="mt-1 relative rounded-md shadow-sm">
            <%= text_input f, field, text_input_class() %>
            <div class="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none">
              <!-- Heroicon name: solid/exclamation-circle -->
              <svg class="h-5 w-5 text-red-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
              </svg>
            </div>
          </div>
          <%= error_paragraph f, field, error_paragraph_class() %>
        </div>
      <% end %>
      <%= submit "Save" %>
    </form>
    """
    #ChukinasWeb.DreadnoughtView.render("component_join_room.html", assigns)
  end

  defp text_input_class, do: [class: "block w-full pr-10 border-red-300 text-red-900 placeholder-red-300 focus:outline-none focus:ring-red-500 focus:border-red-500 sm:text-sm rounded-md"]
  defp label_class, do: [class: "block text-sm font-medium text-gray-700"]
  defp error_paragraph_class do
    "mt-2 text-sm text-red-600"
  end
  defp error_sensitive_text_input(form, field) do
    nil
  end
end
