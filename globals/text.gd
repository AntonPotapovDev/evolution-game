class_name Text
extends RefCounted


const CREATURE: StringName = &"Creature"
const HEALTH: StringName = &"Health"
const ENERGY: StringName = &"Energy"
const STAMINA: StringName = &"Stamina"
const CHILD_PROGRESS: StringName = &"Child progress"
const DIET: StringName = &"Diet"


const LABEL_BY_DIET: Dictionary = {
    CreatureConfig.DietType.HERBIVORE: &"Herbivore",
    CreatureConfig.DietType.OMNIVORE: &"Omnivore",
    CreatureConfig.DietType.CARNIVORE: &"Predator",
}

const TOOLTIP_BY_DIET: Dictionary = {
    CreatureConfig.DietType.HERBIVORE: &"Only plants",
    CreatureConfig.DietType.OMNIVORE: &"Plants and meat",
    CreatureConfig.DietType.CARNIVORE: &"Only meat, hunts",
}
