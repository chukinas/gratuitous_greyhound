defmodule Chukinas.Insider.FSM do

  def handle_event({:flip, _user}, state) do
    new_fsm_state =
      case state.fsm_state do
        :off -> :on
        _ -> :off
      end
    new_count = state.count + 1
    state = state
    |> Map.put(:fsm_state, new_fsm_state)
    |> Map.put(:count, new_count)
    {state, state}
  end
end


#   def handle_event({:call, _from}, :change_name, _state, data) do
#     {:keep_state, data}
#   end

#   # *** *******************************
#   # *** LOBBY

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
#   #   # TODO how to handle the enter state? I want to set a timer when we enter
#   #   # TODO set timer
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

#   # TODO if time runs out, all lose!

#   # *** *******************************
#   # *** VOTE_GUESSER
#   #     Is the Guesser guilty?
#   # TODO there needs to be a timer on this phase as well

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
#   #   # TODO do anything here?
#   # end
# end

# TODO  handle the last person leaving room
# :add_chat_msg | # all # TODO this should be a later feature

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
