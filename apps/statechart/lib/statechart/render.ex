defmodule Statechart.Render do
  @moduledoc """
  Create a file whose single-line json can be pasted into
  https://state-machine-cat.js.org/
  Be sure to change the input type to JSON.
  """
  alias Statechart.Render.Protocol
  alias Statechart.Machine.Spec

  defmodule Transition do
  end

  def new(%Spec{} = spec) do
    statemachine = %{
      states: [],
      transitions: [],
      new_state: &new_state/1,
      put_state: &put_state/3,
      new_transition: &new_transition/3,
      put_transitions: &put_transitions/2,
      put_initial: &put_initial/4
    }
    json =
      Protocol.render(spec, statemachine)
      |> Map.take([:states, :transitions])
      |> Map.update!(:states, fn [root_state] ->
        root_state.statemachine.states
      end)
      |> JSON.encode!
    File.write("/home/jc/projects/my_json_output.js", json)
  end

  defp new_state(local_name_as_atom) when is_atom(local_name_as_atom) do
    %{
      name: local_name_as_atom,
      type: :regular
    }
  end

  defp put_state(%{states: []} = statemachine, %{name: :root} = root_state, [] = _parent) do
    %{statemachine | states: [root_state]}
  end

  defp put_state(statemachine, state, ancestors) when is_list(ancestors) do
    access_keys =
      ancestors
      |> Enum.reverse # so that we start with root
      |> Enum.flat_map(&state_access_keys/1)
    update_in(statemachine, access_keys, &put_state_in_statechart_key(&1, state))
  end

  defp put_transitions(statemachine, transitions) do
    Map.update!(statemachine, :transitions, & transitions ++ &1)
  end

  defp put_initial(statemachine, current_local, ancestors, destination_local) do
    state_name =
      current_local
      |> Atom.to_string
      |> Kernel.<>("_initial")
      |> String.to_atom
    state =
      %{
        name: state_name,
        type: :initial
      }
    transition =
      %{
        from: state_name,
        to: destination_local
      }
    access_keys =
      [current_local | ancestors]
      |> Enum.reverse
      |> Enum.flat_map(&state_access_keys/1)
    statemachine
    |> update_in(access_keys, &put_state_in_statechart_key(&1, state))
    |> put_transitions([transition])
  end

  defp new_transition(from, to, event) do
    event_string =
      event
      |> Atom.to_string
      |> String.split(".")
      |> List.last
      |> String.to_atom
    %{
      from: from,
      to: to,
      event: event_string,
      label: event_string
    }
  end

  # *** *******************************
  # *** ACCESS HELPERS

  defp state_access_keys(local_name) do
    [
      :states,
      Access.filter(&(&1.name == local_name)),
      :statemachine
    ]
  end

  defp put_state_in_statechart_key(statechart, state) do
    case statechart do
      nil ->
        %{
          states: [state],
          transitions: []
        }
      preexisting_map ->
        update_in(preexisting_map.states, &[state | &1])
    end
  end

end
