alias Chukinas.Dreadnought.Command

defmodule ChukinasWeb.DreadnoughtView do
  use ChukinasWeb, :view

  def message(%{socket: _socket} = assigns, do: block) do
    assigns =
      case assigns do
        %{button: _} -> assigns
        _ -> assigns |> Map.put(:button, false)
      end
    render_template("_message.html", assigns, block)
  end

  def command(%{command: %Command{} = command, socket: socket}) do
    {angle, rudder_svg} = case Command.angle(command) do
      x when x > 0 -> {"#{x}°", "rudder_right.svg"}
      x when x < 0 -> {"#{-x}°", "rudder_left4.svg"}
      _ -> {"-", "rudder.svg"}
    end
    assigns =
      command
      |> Map.from_struct
      |> Map.put(:speed_icon_path, Routes.static_path(socket, "/images/propeller.svg"))
      |> Map.put(:angle_icon_path, Routes.static_path(socket, "/images/#{rudder_svg}"))
      |> Map.put(:angle, angle)
    render_template("_command.html", assigns)
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
