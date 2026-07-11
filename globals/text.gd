class_name Text
extends RefCounted


const CREATURE: StringName = &"Creature"
const HEALTH: StringName = &"Health"
const ENERGY: StringName = &"Energy"
const DIET: StringName = &"Diet"

const LABEL_BY_DIET: Dictionary = {
    CreatureConfig.DietPhase.HERBIVORE: &"Herbivore",
    CreatureConfig.DietPhase.OMNIVORE_SCAVENGER: &"Scavenger",
    CreatureConfig.DietPhase.OMNIVORE_OPPORTUNIST: &"Opportunist",
    CreatureConfig.DietPhase.CARNIVORE: &"Predator",
}

const TOOLTIP_BY_DIET: Dictionary = {
    CreatureConfig.DietPhase.HERBIVORE: &"Only plants",
    CreatureConfig.DietPhase.OMNIVORE_SCAVENGER: &"Omnivore, does not hunt",
    CreatureConfig.DietPhase.OMNIVORE_OPPORTUNIST: &"Omnivore, hunts if needed",
    CreatureConfig.DietPhase.CARNIVORE: &"Only meat",
}
