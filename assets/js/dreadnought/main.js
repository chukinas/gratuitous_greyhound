import CommandCardHooks from "./command_card.js";
import SliderHooks from "./constant_game_time.js";
import UnitHooks from "./unit.js";
import { CheckGsapLoad } from "./gsap_experiment.js";

export default { ...CommandCardHooks, ...SliderHooks, ...UnitHooks, CheckGsapLoad }
