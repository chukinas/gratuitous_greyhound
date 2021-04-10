import UnitHooks from "./hooks/unit.js";
import GsapHooks from "./proofs_of_concept/gsap_experiment.js";
import ZoomHooks from "./hooks/pinch_zoom.js";
import PanHooks from "./hooks/pan.js";

export default {
  ...UnitHooks, 
  ...GsapHooks,
  ...ZoomHooks,
  ...PanHooks,
}
