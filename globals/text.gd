class_name Text
extends RefCounted


const CREATURE: StringName = &"Creature"
const HEALTH: StringName = &"Health"
const ENERGY: StringName = &"Energy"
const STAMINA: StringName = &"Stamina"
const CHILD_PROGRESS: StringName = &"Child progress"
const DIET: StringName = &"Diet"


const LABEL_BY_DIET: Dictionary = {
    CreatureConfig.DietPhase.HERBIVORE: &"Herbivore",
    CreatureConfig.DietPhase.OMNIVORE: &"Omnivore",
    CreatureConfig.DietPhase.CARNIVORE: &"Predator",
}

const TOOLTIP_BY_DIET: Dictionary = {
    CreatureConfig.DietPhase.HERBIVORE: &"Only plants",
    CreatureConfig.DietPhase.OMNIVORE: &"Plants and meat",
    CreatureConfig.DietPhase.CARNIVORE: &"Only meat, hunts",
}
