import CommandCardHooks from "./hooks/command_card.js";
// import SliderHooks from "./constant_game_time.js";
import UnitHooks from "./hooks/unit.js";
// import { CheckGsapLoad } from "./gsap_experiment.js";
import SegmentHooks from "./hooks/segment.js";

export default {
  ...CommandCardHooks,
  ...UnitHooks, 
  ...SegmentHooks,
}
