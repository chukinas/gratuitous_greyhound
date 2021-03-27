alias ChukinasWeb.Router.Helpers

defmodule ChukinasWeb.Dreadnought.Feedback do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~L"""
    <div class="fixed inset-0 bg-black bg-opacity-75">
     <form phx-submit="submit" phx-target="<%= @myself %>">
       <label for="feedback" class="text-white">Your Feedback:</label>
       <textarea id="feedback" name="feedback"></textarea>
       <input type="submit" value="Submit">
     </form>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("submit", %{"feedback" => feedback}, socket) do
    IO.puts(feedback)
    {:noreply, socket}
  end

end
