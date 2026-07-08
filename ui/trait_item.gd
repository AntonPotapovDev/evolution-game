class_name TraitItem
extends FoldableContainer


func init(trait_name: String, description: String):
    title = trait_name
    $Description.text = description
