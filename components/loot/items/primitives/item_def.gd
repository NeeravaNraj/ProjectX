class_name ItemDefinition extends Resource

@export var name: String
@export var description: String
@export var rarity: LootPool.Rarity

@export var stats: Array[ItemStat] = []

@export var view_scene: PackedScene
