defmodule SunsCore.Machine.PassiveAttacksStep do

  use Statechart, :machine

  defmachine external_states: ~w/jump_out_step/a do

    alias SunsCore.Context.PassiveAttacksStep, as: PassiveAttacksContext

    on_enter &PassiveAttacksContext.init_player_order/1
    defstate :calculating_avail_attacks, default: true do
      on_enter &PassiveAttacksContext.calc_avail_attacks/1
      autotransition :any_avail_attacks?
    end
    decision :any_avail_attacks?,
      &PassiveAttacksContext.any_avail_attacks?/1,
      if_true: :attacking,
      else: :removing_attacking_player
    defstate :attacking do
      SkipPassiveAttack >>> :picking_next_player
      PassiveAttack >>> :any_destroyed_ships?
    end
    decision :any_destroyed_ships?,
      &PassiveAttacksContext.any_destroyed_ships?/1,
      if_true: :removing_casualties2,
      else: :picking_next_player
    defstate :removing_casualties2 do
      RemoveCasualties >>> :picking_next_player
    end
    defstate :picking_next_player do
      on_enter &PassiveAttacksContext.picking_next_player/1
      autotransition :calculating_avail_attacks
    end
    defstate :removing_attacking_player do
      on_enter &PassiveAttacksContext.remove_current_player/1
      autotransition :any_players_left?
    end
    decision :any_players_left?,
      &PassiveAttacksContext.any_players_left?/1,
      if_true: :picking_next_player,
      else: :jump_out_step
    on_exit &PassiveAttacksContext.cleanup/1
  end

end
