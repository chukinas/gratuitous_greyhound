defmodule ChukinasWeb.Dreadnought.FeedbackComponent do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~L"""
    <div class="fixed inset-0 bg-black bg-opacity-75" x-data="{browser:navigator.userAgent}">
     <form phx-submit="submit" phx-target="<%= @myself %>">
       <label for="feedback" class="text-white">Your Feedback:</label>
       <textarea id="feedback" name="feedback">Just some stuff...</textarea>
       <input x-bind:value="browser" name="browser" type="hidden">
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
  def handle_event("submit", %{"feedback" => _feedback, "browser" => _browser} = params, socket) do
    IOP.inspect params
    {:noreply, socket}
  end

end
