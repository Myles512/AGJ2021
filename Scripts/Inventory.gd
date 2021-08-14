extends Control


# name, count, graphic, objectToSpawn
var items = [
	["Turret", 3, "res://GFX/turret.png", "res://Scenes/Turret.tscn"],
	["Godot Icon", 1, "res://icon.png", "res://Scenes/Turret.tscn"],
	["Turret 2", 7, "res://GFX/turret.png", "res://Scenes/Turret.tscn"]
	]

var mouseInsideBox = false
var selectedRealWorldItem = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$ItemList.clear()
	for item in items:
		$ItemList.add_item(createItemText(item), load(item[2]))

func _process(delta):
	if selectedRealWorldItem:
		selectedRealWorldItem.position = get_viewport().get_mouse_position()

func _input(event):
	if event.is_action_pressed("mouse_left_button") and mouseInsideBox:
		#$ItemList.select()
		var selectedItems = $ItemList.get_selected_items()
		if len(selectedItems) == 0:
			return	#nothing to do if nothing is selected
		var selectedItem = items[selectedItems[0]]
		if selectedItem[1] <= 0:
			return	# nothing to do if no items remain
		var res = load("res://Scenes/Turret.tscn")
		var obj = res.instance()
		get_tree().root.add_child(obj)
		selectedRealWorldItem = obj

		for i in selectedItems:
			updateItemCount(i, -1)

	if event.is_action_released("mouse_left_button"):
		selectedRealWorldItem = null


func _on_ItemList_nothing_selected():
#	$ItemList.unselect_all()
	pass

func updateItemCount(index, delta):
	var itemData = items[index]
	itemData[1] += delta
	$ItemList.set_item_text(index, createItemText(itemData))

func createItemText(item):
	return str(item[1])  + "x " + item[0]

func _on_ItemList_mouse_entered():
	mouseInsideBox = true


func _on_ItemList_mouse_exited():
	mouseInsideBox = false


func _on_ItemList_item_selected(index):
	print("Item selected")
	pass # Replace with function body.
