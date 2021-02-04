import constantGameTimeHooks from "./constant_game_time.js";
import unitHooks from "./unit.js";
import { CheckGsapLoad, MoveSlider } from "./gsap_experiment.js";

export default { ...constantGameTimeHooks, ...unitHooks, CheckGsapLoad, MoveSlider }
