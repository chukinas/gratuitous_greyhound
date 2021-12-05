defmodule SunsCore.Context.PassiveAttacksStep do

  alias SunsCore.Mission.Attack
  alias SunsCore.Context
  alias SunsCore.Mission.PlayerOrderTracker
  require Logger

  defmodule Subcontext do
    @derive [SunsCore.Mission.Subcontext]
    use Util.GetterStruct
    getter_struct do
      field :player_order_tracker, PlayerOrderTracker.t
      field :avail_attacks, [Attack.t]
    end

    def new(%Context{} = ctx) do
      active_player_id = 1
      player_order_tracker =
        ctx
        |> Context.helms
        |> PlayerOrderTracker.new(active_player_id)
      %__MODULE__{
        player_order_tracker: player_order_tracker,
        avail_attacks: []
      }
    end
  end

  @type t :: Context.t

  # *** *******************************
  # *** REDUCERS

  def calc_avail_attacks(%Context{} = context) do
    subcontext =
      context
      |> Context.fetch_subcontext!(Subcontext)
    # TODO do something with the subcontext
    Context.set(context, subcontext)
  end

  def cleanup(ctx) do
    Context.clear_subcontext(ctx, Subcontext)
  end

  def init(%Context{} = ctx) do
    Context.set(ctx, Subcontext.new(ctx))
  end

  def picking_next_player(ctx) do
    Logger.warn "TODO: `picking_next_player/1` needs implemented"
    ctx
  end

  def remove_current_player(ctx) do
    Logger.warn "TODO: `remove_current_player/1` needs implemented"
    ctx
  end

  # *** *******************************
  # *** CONVERTERS

  def any_avail_attacks?(%Context{}) do
    Logger.warn "TODO: any_avail_attacks? needs implemented"
    false
  end

  def any_destroyed_ships?(%Context{}) do
    Logger.warn "TODO: any_destroyed_ships? needs implemented"
    false
  end

  def any_players_left?(%Context{}) do
    Logger.warn "TODO: any_players_left? needs implemented"
    false
  end

end

# Passive Attacks Step
# There's an active battlegroup...
# Get all objects and ships
# Filter (get) those that
#   have aux weapons
#   are on same table
#   have the bg in arc and range
#   not friendly
# CEOs take turns attacking the active bg. TODO how do neutrals factor into this?
# At least in the beginning, this firing will be automatic
# (Don't give CEOs the option of not firing)
# If the passive bg/obj has at least one ship/obj that meet the criteria, then it attacks:
# Gather attack dice
#   For each ship/obj that has at least one active bg ship in arc and range..
#   it contributes all its aux attack dice to the attack
# roll to hit
#   roll dice. if lte silhouette, it's a hit
#   engage: reroll misses
#   TODO: can a passive group ever be engaged?
# discard misses (as above) and duds (those that rolled their max value)
# Add a hit for any crits (roll of 1)
# Saving Throws
#   target must have Shields of at least 1
#     Although, I don't need to actually check this, b/c a Shields of 0 will never succeed?
#   roll the pile of hits
#   lte Shields blocks the hit. discard that hit.
#   Any duds (rolled max) don't succeed
# Are there ever any mixed targets?
# Does damage amount ALWAYS map to dice sides?
