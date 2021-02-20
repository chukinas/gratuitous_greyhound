import CommandCardHooks from "./command_card.js";
import GsapHooks from "./gsap.js";
import SliderHooks from "./constant_game_time.js";
import UnitHooks from "./unit.js";
import { CheckGsapLoad } from "./gsap_experiment.js";
import SegmentHooks from "./segment.js";

export default {
  ...CommandCardHooks,
  ...GsapHooks,
  ...SliderHooks, 
  ...UnitHooks, 
  ...SegmentHooks,
  CheckGsapLoad,
}
