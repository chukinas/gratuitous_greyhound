defmodule ChukinasWeb.Dreadnought.FeedbackComponent do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~L"""
    <div class="fixed inset-0 bg-black bg-opacity-75" x-data="{ text: 'Your Feedback' }" >
     <form phx-submit="submit" phx-target="<%= @myself %>">
       <label for="feedback" class="text-white" x-text="text"></label>
       <textarea id="feedback" name="feedback">Just some stuff...</textarea>
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
