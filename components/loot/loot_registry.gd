class_name LootRegistry extends Node

enum Rarity {
	Common,
	Uncommon,
	Rare,
	Epic,
	Legendary
}

@export var pool: LootPool

const RARITY_WEIGHTS: Dictionary[Rarity, float] = {
	Rarity.Common: 50.0,
	Rarity.Uncommon: 30.0,
	Rarity.Rare: 15.0,
	Rarity.Epic: 4.0,
	Rarity.Legendary: 1.0
}
var _pool: Dictionary[Rarity, Array] = {}
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	assert(pool, "Loot registry cannot function without a loot pool!")
	_pool[Rarity.Common] = pool.common
	_pool[Rarity.Uncommon] = pool.uncommon
	_pool[Rarity.Rare] = pool.rare
	_pool[Rarity.Epic] = pool.epic
	_pool[Rarity.Legendary] = pool.legendary

func pick_rarity(
	min_rarity: Rarity = Rarity.Common,
	max_rarity: Rarity = Rarity.Legendary
) -> Rarity:
	assert(min_rarity <= max_rarity)
	if min_rarity == max_rarity: return min_rarity
	
	var weights := PackedFloat32Array()
	
	for rarity in range(min_rarity, max_rarity + 1):
		weights.append(rarity)

	return (min_rarity + _rng.rand_weighted(weights)) as Rarity

func roll_item(rarity: Rarity) -> ItemDefinition:
	var items: Array = _pool[rarity]
	
	if items.is_empty(): return  null

	return _pool[rarity].pick_random()