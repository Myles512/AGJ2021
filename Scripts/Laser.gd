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



#func _process(delta):



func _physics_process(delta):
	set_point_position(0, start_pos)
	set_point_position(1, end_pos)
	#visible = originating_turret.on
	if originating_turret == null:
		queue_free()
	#turn off all lasers if the originating turret is off
	elif !originating_turret.on:
		visible = false
		turn_off_next_laser(visible)
		turn_off_object()
	#if the previous laser segment is turned off, this one also needs to be off
	elif prev_laser != null and !prev_laser.visible:
		visible = false
		turn_off_object()
	#the raycast is detecting a collision
	elif $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()	# what we hit
		#if the raycast hit a turret that is not the originating turret, turn it on.
		if collider.owner != originating_turret:
			if collider != objectHit and objectHit:
				updateHittingObject(objectHit, false)
			objectHit = collider.owner
			updateHittingObject(objectHit, true)
		var collision_point_world = $RayCast2D.get_collision_point()
		var collision_point = to_local(collision_point_world)
		end_pos = collision_point
		#do not bounce off of non-reflective things
		if !collider.is_in_group("reflective"):#collider.owner.is_in_group("turret") or 
#			print(collider.name)
			turn_off_next_laser(false)
		#update the next laser segment, as it's bouncing off of something.
		else:
			#figure out the position and angle of reflection of the next laser segment
			var collision_normal = $RayCast2D.get_collision_normal()
			var direction_normalized = (to_global(end_pos) - to_global(start_pos)).normalized()
			var direction_reflected = direction_normalized.bounce(collision_normal)
			var angle = rad2deg(atan2(direction_reflected.y, direction_reflected.x))
			make_laser()
			next_laser.position = collision_point_world
			next_laser.rotation_degrees = angle + 90 #abs(angle)
			next_laser.visible = true
	else:
		turn_off_object()
		end_pos = start_pos
		end_pos.y -= laser_distance
		turn_off_next_laser(false)
	if end_pos != start_pos:
		$Particles2D.position = (end_pos+start_pos)/2
		$Particles2D.process_material.emission_box_extents.y = (end_pos+start_pos).length()/2



func turn_off_object():
	if objectHit:
		updateHittingObject(objectHit, false)
		objectHit = null




func updateHittingObject(obj, hitting):
	if obj.has_method("updatePowerSource"):
		obj.updatePowerSource(originating_turret, hitting)



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

