class_name Inventory extends Node


@export var player: Player

class ItemSlot:
	var item: Variant
	var quantity: int
	
	func _init(p_item: Variant, p_quantity: int = 1) -> void:
		item = p_item
		quantity = p_quantity
	
var _inventory: Dictionary[String, ItemSlot] = {}

func _ready() -> void:
	assert(player, "Inventory needs access Player.")

func pickup(item: Variant):
	var added = true
	
	if _inventory.has(item.id):
		if _inventory[item.id].quantity < INT16_MAX:
			_inventory[item.id].quantity += 1
		else: added = false
	else:
		_inventory[item.id] = ItemSlot.new(item)
	
	return added

func drop(item_id: String, quantity: int = 1):
	if not _inventory.has(item_id): return
	var slot = _inventory[item_id]
	
	if slot.quantity - quantity <= 0:
		_inventory.erase(item_id)
	else:
		slot.quantity -= quantity

func _update_stats():
	pass
