defmodule ChukinasWeb.LayoutView do
  use ChukinasWeb, :view
  use ChukinasWeb.Components

  def crinkled_paper_path(socket) do
    Routes.static_path socket, "/images/crinkled_paper_20210517.jpg"
  end

end
