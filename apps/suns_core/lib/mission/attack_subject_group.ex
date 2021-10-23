# TODO rename SubjectGroup ?
# TODO either way, unify module and file names
defprotocol SunsCore.Mission.Attack.Subject do

  alias SunsCore.Mission.Controller
  alias SunsCore.Mission.Weapon
  alias SunsCore.Space.TablePose

  @spec silhouette(t) :: integer
  def silhouette(subject)

  @spec controller(t) :: Controller.t
  def controller(subject)

  # TODO rename member_poses?
  @spec individuals(t) :: [TablePose.t]
  def individuals(subject)

  @spec max_attack_dice(t, Weapon.type) :: integer
  def max_attack_dice(subject, weapon_type)

  @spec weapon_range(t, Weapon.type) :: Weapon.range
  def weapon_range(subject, weapon_type)

  @spec weapon_arc(t, Weapon.type) :: integer
  def weapon_arc(subject, weapon_type)

end
