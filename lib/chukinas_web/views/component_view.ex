defmodule ChukinasWeb.ComponentView do

  use ChukinasWeb, :view

  def render_gsap_import, do: render("gsap_import.html", [])

  def render_toggle(id, label, selected?, attrs \\ []) do
    assigns =
      [
        id: id,
        label: label,
        selected?: selected?,
        attrs: attrs
      ]
    render("toggle.html", assigns)
  end

end
