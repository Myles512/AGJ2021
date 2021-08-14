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
		selectedRealWorldItem.position = get_global_mouse_position()

func _input(event):
	if event.is_action_pressed("mouse_left_button"):
		if mouseInsideBox:
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
		else:
			var pos = get_global_mouse_position()
			var intersects = get_world_2d().get_direct_space_state().intersect_point(
					pos, 32, [], 0x7FFFFFFF, true, true)
			for i in intersects:
				selectedRealWorldItem = i["collider"].owner
				break

	if event.is_action_released("mouse_left_button"):
		updateMouseInsideBox()
		if mouseInsideBox:
			if selectedRealWorldItem:
				var itemName = selectedRealWorldItem.name
				if "@" in itemName:
					itemName = str(itemName).split("@")[1]	# duplicate items in the scene are named @Name@#, where # is some number
				for i in range(len(items)):
					if items[i][0] == itemName:
						updateItemCount(i, 1)
				selectedRealWorldItem.queue_free()
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

func updateMouseInsideBox():
	var pos = get_global_mouse_position()
	mouseInsideBox = $ItemList.get_global_rect().has_point(pos)


func _on_ItemList_item_selected(index):
	pass # Replace with function body.
