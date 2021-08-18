defmodule DreadnoughtWeb.TestHelpers do

  require ExUnit.Assertions
  import ExUnit.Assertions
  import Phoenix.LiveViewTest

  def click(view, selector) do
    view
    |> element(selector)
    |> render_click
    view
  end

  def assert_element(view, selector) do
    assert has_element?(view, selector)
    view
  end

  def form_submit(view, selector, form_data) do
    view
    |> form(selector, form_data)
    |> render_submit
    view
  end

  #def refute_element(view, selector, text_filter \\ nil) do
  #  refute has_element?(view, selector, text_filter)
  #  view
  #end

end
