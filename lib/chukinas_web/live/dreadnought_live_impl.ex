alias Chukinas.Sessions
alias Chukinas.Sessions.Room
alias ChukinasWeb.Router.Helpers, as: Routes

defmodule ChukinasWeb.DreadnoughtLive.Impl do

  import Phoenix.LiveView, only: [assign: 2]

  #def assign_room_param(socket, %{"room" => room}) do
  #  assign(socket, room_param: room)
  #end
  #def assign_room_param(socket, _params) do
  #  assign(socket, room_param: nil)
  #end

  def standard_assigns(socket) do
    gallery? = socket.assigns.live_action == :gallery
    tabs = [
      %{
        title: "Play",
        path: Routes.dreadnought_path(socket, :join),
        current?: !gallery?,
        show_header: false
      },
      %{
        title: "Gallery",
        path: Routes.dreadnought_path(socket, :gallery),
        current?: gallery?,
        show_header: true
      },
    ]
    active_tab = Enum.find(tabs, & &1.current?)
    title = case active_tab do
      %{title: title} -> title
      nil -> nil
    end
    page_title = case title do
      nil -> "Dreadnought"
      title -> "Dreadnought | #{title}"
    end
    assign(socket,
      tabs: tabs,
      page_title: page_title,
      header: if(active_tab.show_header, do: title, else: nil)
    )
  end

  def get_room_name(socket) do
    case socket.assigns.room do
      nil -> nil
      %Room{} = room -> Room.name(room)
    end
  end

end
