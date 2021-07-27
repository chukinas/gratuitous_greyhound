import BackgroundHooks from "./hooks/background.js";
import PanHooks from "./hooks/zoom_pan.js";
import GsapHooks from "./proofs_of_concept/gsap_experiment.js";
import TurnHooks from "./hooks/turnNumber.js";
import UnitHooks from "./hooks/unit.js";

export default {
  ...BackgroundHooks,
  ...GsapHooks,
  ...PanHooks,
  ...TurnHooks,
  ...UnitHooks, 
}
