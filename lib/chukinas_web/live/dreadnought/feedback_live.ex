defmodule ChukinasWeb.Dreadnought.FeedbackComponent do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~L"""
    <div id="feedbackForm" class="pointer-events-auto" x-data="{browser:navigator.userAgent, isSubmitted: false}">
     <form phx-submit="submit" phx-target="<%= @myself %>">
       <label for="feedback" class="text-white hidden">Your Feedback:</label>
       <textarea id="feedback" name="feedback" class="block"></textarea>
       <input x-bind:value="browser" name="browser" type="hidden" value="hello">
       <input
         id="feedbackSubmit"
         type="submit"
         value="Submit"
         class="p-4 pl-0 font-bold uppercase bg-transparent"
         @click=" isSubmitted = true "
       >
     </form>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("submit", %{"feedback" => feedback, "browser" => _browser} = _params, socket) do
    if String.length(String.trim feedback) > 0 do
      Chukinas.Email.feedback_email(feedback)
      |> Chukinas.Mailer.deliver_now!()
    end
    {:noreply, socket}
  end

end
