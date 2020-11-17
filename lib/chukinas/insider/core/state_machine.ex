defmodule Chukinas.Insider.Core.StateMachine do
  alias Chukinas.Insider.Core.{State, Event, Phase, Users}
  alias Chukinas.User

  @spec handle_event(Event.t(), User.t(), State.t()) :: State.t()
  def handle_event(event, user, state)

  # *** *******************************
  # *** PRE-EVENT PIPELINE

  # *** Look up user's ID
  def handle_event(event, %{id: :unk} = user, state) do
    IO.puts("id unk")
    user_id = Users.lookup_user_id(state.users, user)
    new_user = User.set_id(user, user_id)
    handle_event(event, new_user, state)
  end

  # *** If user is new, add her
  def handle_event(event, %{id: :new} = user, state) do
    IO.puts("id new")
    users = Users.add(state.users, user)
    new_state = State.set_users(state, users)
    new_user = User.set_id(user, :unk)
    handle_event(event, new_user, new_state)
  end

  def handle_event(%{name: :get_state}, _user, state) do
    IO.puts("getting state")
    state
  end

  # *** *******************************
  # *** STATE-ALTERING EVENTS

  def handle_event(%{version_incremented?: false} = event, user, state) do
    handle_event(
      Event.version_is_incremented(event),
      user,
      State.increment_count(state)
    )
  end

  def handle_event(%{name: :flip}, _user, state) do
    IO.puts("flipping")

    state
    |> State.set_phase(&Phase.flip/1)
  end

  # *** *******************************
  # *** AUTOMATIC EVENTS
  # *** handle_event/2

  @spec handle_event(Event.t(), State.t()) :: State.t()
  def handle_event(event, state)

  def handle_event(%{name: :unregister_pid, payload: pid}, state) do
    users = Users.unregister_pid(state.users, pid)
    State.set_users(state, users)
  end

  def handle_event(%{version_incremented?: false} = event, state) do
    handle_event(
      Event.version_is_incremented(event),
      State.increment_count(state)
    )
  end

end













#   def handle_event({:call, from}, :start_game, :lobby, data) do
#     # GUARD: min player count
#     # DATA: assign roles
#     _next_and_reply(:introduction, data, from)
#   end

#   # *** *******************************
#   # *** INTRODUCTION

#   def handle_event({:call, from}, :end_intro, :introduction, data) do
#     _next_and_reply(:play_questions, data, from)
#   end

#   # *** *******************************
#   # *** PLAY

#   # def handle_event(:enter, :play, data) do
#   #   #  how to handle the enter state? I want to set a timer when we enter
#   #   #  set timer
#   #   play_duration = Game.get_play_duration(data)
#   #   {:keep_state, data, [{:timeout, :play}, play_duration, :]}
#   # end

#   def handle_event({:call, _from}, {:ask, _question}, :play, data) do
#     # Player is not Master
#     {:keep_state, data}
#   end

#   def handle_event({:call, _from}, {:respond, _response}, :play, data) do
#     # Master only
#     {:keep_state, data}
#   end

#   def handle_event({:call, _from}, :guess, :play, data) do
#     # Master only
#     {:next_state, :voting_guesser, data}
#   end

#   #  if time runs out, all lose!

#   # *** *******************************
#   # *** VOTE_GUESSER
#   #     Is the Guesser guilty?
#   #  there needs to be a timer on this phase as well

#   def handle_event({:call, from}, {:vote_guesser, vote}, :voting_guesser, data) do
#     {result, data} = Game.handle_guesser_vote(data, vote, from)

#     case result do
#       :voting_incomplete -> {:keep_state, data}
#       {:game_end, winner} -> {:next_state, {:game_end, winner}, data}
#       :continue -> {:next_state, :open_voting, data}
#     end
#   end

#   # *** *******************************
#   # *** OPEN_VOTING

#   # def handle_event({:call, from}, {:open_vote, vote}, :open_voting, data) do
#   #   {result, data} = Game.handle_open_vote(data, vote, from)
#   #   case result do
#   #     :voting_incomplete -> {:keep_state, data}
#   #     :voting_tied -> {:next_state, :tiebreaking, data}
#   #     {:game_end, winner} -> {:next_state, {:game_end, winner}, data}
#   #   end
#   # end

#   # *** *******************************
#   # *** BREAK_TIE

#   def handle_event({:call, from}, {:break_tie, vote}, :tiebreaking, data) do
#     {result, data} = Game.handle_tie_break(data, vote, from)

#     case result do
#       :invalid_vote -> {:keep_state, data}
#       {:game_end, winner} -> {:next_state, {:game_end, winner}, data}
#     end
#   end

#   # *** *******************************
#   # *** GAME_END

#   # def handle_event(:enter, _event, {:game_end, winner}, data) do
#   #   #  do anything here?
#   # end
# end

#   handle the last person leaving room
# :add_chat_msg | # all #  this should be a later feature

# user
#   tags

# question
#   id
#   text
#   assoc_user
#   answer
#   tags -

# state
#   users
#   answered_questions
#   pending_questions
#   time.start?
#   time.end?

# https://www.ultraboardgames.com/insider/game-rules.php
# http://davekuhlman.org/fsm-elixir-python.html

# event handler result: https://erlang.org/doc/man/gen_statem.html#type-event_handler_result
