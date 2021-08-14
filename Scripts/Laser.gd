extends Line2D

export(PackedScene) var laser_scene = load("res://Scenes/Laser.tscn")
export var laser_distance = 500

var start_pos = Vector2()
var end_pos = Vector2()
var next_laser
var prev_laser
var originating_turret
var root_node
var objectHit = null



func _ready():
	root_node = get_tree().get_current_scene()
	end_pos = start_pos
	end_pos.y -= laser_distance
	$RayCast2D.cast_to = end_pos



func _process(delta):
	set_point_position(0, start_pos)
	set_point_position(1, end_pos)



func _physics_process(delta):
	visible = originating_turret.on
	if !originating_turret.on:
		#visible = false
		turn_off_next_laser(visible)
	elif prev_laser != null and !prev_laser.visible:
		visible = false
	elif $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()	# what we hit
		if collider.owner != originating_turret:
			if collider != objectHit and objectHit:
				updateHittingObject(objectHit, false)
			objectHit = collider.owner
			updateHittingObject(objectHit, true)
		
		
		
		var collision_point_world = $RayCast2D.get_collision_point()
		var collision_point = to_local(collision_point_world)
#		print($RayCast2D.get_collider().name)
		var collision_normal = $RayCast2D.get_collision_normal()
		end_pos = collision_point
		
		var direction_normalized = (to_global(end_pos) - to_global(start_pos)).normalized()
#		var test_bounced = test_normalized.bounce(collision_normal)
#		var test_angle = rad2deg(test_bounced.angle())
		var direction_reflected = direction_normalized.bounce(collision_normal)
		var angle = rad2deg(atan2(direction_reflected.y, direction_reflected.x))
#		print(str(test_normalized) + " / " + str(test_bounced) + " / " + str(test_angle))
#		print(str(test_normalized) + " / " + str(angle))
#		print(str(angle))
		if collider.owner.is_in_group("turret"):
			turn_off_next_laser(false)
		else:
			make_laser()
			next_laser.visible = true
			next_laser.rotation_degrees = angle + 90 #abs(angle)
			next_laser.position = collision_point_world
	else:
		if objectHit:
			updateHittingObject(objectHit, false)
			objectHit = null
		end_pos = start_pos
		end_pos.y -= laser_distance
		turn_off_next_laser(false)




func updateHittingObject(obj, hitting):
	if obj.has_method("setOn"):
		obj.setOn(hitting)



func make_laser():
	if next_laser == null:
		print(self.name + " creating new laser")
		var new_laser = laser_scene.instance()
		root_node.add_child(new_laser)
		next_laser = new_laser
		next_laser.prev_laser = self
		next_laser.originating_turret = originating_turret

func turn_off_next_laser(_visible):
	if next_laser != null:
		next_laser.visible = _visible
		next_laser.turn_off_next_laser(_visible)

