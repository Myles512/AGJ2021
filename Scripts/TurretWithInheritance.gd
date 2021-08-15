extends "res://Scripts/PickupableObject.gd"

export(PackedScene) var laser_scene
export(bool) var on = true
var powerSources = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(_delta):
	if on:
		make_laser()
		next_laser.visible = true

func updatePowerSource(powerSource, active):
	if active:
		if not powerSources.has(powerSource):
			powerSources.append(powerSource)
	else:
		if powerSources.has(powerSource):
			powerSources.remove(powerSources.find(powerSource))
	updatePowerState()

func updatePowerState():
	on = len(powerSources) > 0	# true if greater than 0
	set_texture()

func set_texture():
	if on:
		$Sprite.texture = load("res://GFX/Simple Turret2.png")
	else:
		$Sprite.texture = load("res://GFX/Simple Turret1.png")

func make_laser():
	if next_laser == null:
		var new_laser = laser_scene.instance()
#		new_laser.position = 
		root_node.add_child(new_laser)
		next_laser = new_laser
	next_laser.position = to_global($Laserstart.position)
	next_laser.rotation_degrees = rotation_degrees
	next_laser.originating_turret = self
	
#func make_laser():
#	if lasers_array.size() == 0:
#		var new_laser = laser_scene.instance()
#		new_laser.position = $Laserstart.position
#		new_laser.end_pos.y -= laser_distance
#		add_child(new_laser)
#		lasers_array.append(new_laser)
#	var space_state = get_world_2d().direct_space_state
#	var testpoint = Vector2()
#	if $RayCast2D.is_colliding():
##		print($RayCast2D.get_collider().to_string())
#		testpoint = transform.xform_inv($RayCast2D.get_collision_point())
#		var collision_normal = $RayCast2D.get_collision_normal()
##		print(collision_normal)
#		var reflected_angle = (testpoint - position).normalized().bounce(collision_normal)
#		print(reflected_angle)
#	else:
#		testpoint += $Laserstart.position
#		testpoint.y -= laser_distance
#	if debug_drawraycast:
#		$DebugLaser.set_point_position(0, $Laserstart.position)
#		$DebugLaser.set_point_position(1, testpoint)
#		$DebugLaser.visible = true
#	var result = space_state.intersect_ray($Laserstart.position, testpoint, [self])
#	print(result.size())
#	if result.collider != null:
#		print(result[0].collider.name)
