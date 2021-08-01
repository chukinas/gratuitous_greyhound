defmodule ChukinasWeb.ComponentView do

  alias ChukinasWeb.SharedView

  def render_gsap_import, do: render_template("import_gsap.html")

  # *** *******************************
  # *** PRIVATE

  defp render_template(template, assigns \\ []) do
    SharedView.render(template, assigns)
  end

end
