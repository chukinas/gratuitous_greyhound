import UnitHooks from "./hooks/unit.js";
import PanHooks from "./hooks/zoom_pan.js";
import GsapHooks from "./proofs_of_concept/gsap_experiment.js";
import TurnHooks from "./hooks/turnNumber.js";

export default {
  ...UnitHooks, 
  ...GsapHooks,
  ...PanHooks,
  ...TurnHooks,
}
