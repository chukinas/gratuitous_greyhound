defmodule ChukinasWeb.JustOneLive do
  use ChukinasWeb, :live_view

  #############################################################################
  # HELPERS
  #############################################################################

  defp assign_tentative_uuid(socket) do
    # saved to localstorage if one doesn't already exist
    assign(socket, :uuid, UUID.uuid4())
  end

  #############################################################################
  # CALLBACKS
  #############################################################################

  @impl true
  # def mount(%{path_params: %{"room" => room}}, _session, socket) do
  def mount(%{"room" => room}, _session, socket) do
    socket =
      socket
      |> assign_tentative_uuid
      |> assign(:room, room)

    socket |> inspect |> IO.puts()
    {:ok, socket}
  end

  @impl true
  # def mount(%{path_params: %{"room" => room}}, _session, socket) do
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_tentative_uuid
      |> assign(:room, "")

    socket |> inspect |> IO.puts()
    {:ok, socket}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, results: search(query), query: query)}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case search(query) do
      %{^query => vsn} ->
        {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "No dependencies found matching \"#{query}\"")
         |> assign(results: %{}, query: query)}
    end
  end

  @impl true
  def handle_event("uuid", uuid, socket) do
    IO.puts(uuid)
    {:noreply, assign(socket, uuid: uuid)}
  end

  defp search(query) do
    if not ChukinasWeb.Endpoint.config(:code_reloader) do
      raise "action disabled when not in development"
    end

    for {app, desc, vsn} <- Application.started_applications(),
        app = to_string(app),
        String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
        into: %{},
        do: {app, vsn}
  end
end
