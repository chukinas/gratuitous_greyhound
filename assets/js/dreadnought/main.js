import CommandCardHooks from "./hooks/command_card.js";
// import SliderHooks from "./constant_game_time.js";
import UnitHooks from "./hooks/unit.js";
import GsapHooks from "./proofs_of_concept/gsap_experiment.js";
import SegmentHooks from "./hooks/segment.js";
import ZoomHooks from "./hooks/pinch_zoom.js";
import PanHooks from "./hooks/pan.js";

export default {
  ...CommandCardHooks,
  ...UnitHooks, 
  ...GsapHooks,
  ...SegmentHooks,
  ...ZoomHooks,
  ...PanHooks,
}
