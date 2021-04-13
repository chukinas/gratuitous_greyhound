defmodule ChukinasWeb.DreadnoughtView do
  use ChukinasWeb, :view

  def sprite(opts \\ []) do
    sprite = Keyword.fetch!(opts, :sprite)
    rect = if Keyword.get(opts, :center_on_origin?, true) do
      sprite.rect_centered
    else
      sprite.rect_tight
    end
    render_template("sprite.html",
      rect: rect,
      image: sprite.image,
      socket: Keyword.fetch!(opts, :socket),
      clip_path: sprite.clip_path,
    )
  end

  def message(%{socket: _socket} = assigns, do: block) do
    assigns =
      case assigns do
        %{button: _} -> assigns
        _ -> assigns |> Map.put(:button, false)
      end
    render_template("_message.html", assigns, block)
  end

  defp render_template(template, assigns, block) do
    assigns =
      assigns
      |> Map.new()
      |> Map.put(:inner_content, block)
    render template, assigns
  end

end

# https://bernheisel.com/blog/phoenix-liveview-and-views
# https://www.wyeworks.com/blog/2020/03/03/breaking-up-a-phoenix-live-view/
# https://fullstackphoenix.com/tutorials/nested-templates-and-layouts-in-phoenix-framework
