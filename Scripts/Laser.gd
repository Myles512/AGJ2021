extends Line2D

export(PackedScene) var laser_scene = load("res://Scenes/Laser.tscn")
export var laser_distance = 500

var start_pos = Vector2()
var end_pos = Vector2()
var next_laser
var laser_root_source
var root_node


func _ready():
	root_node = get_tree().get_current_scene()
	end_pos = start_pos
	end_pos.y -= laser_distance
	$RayCast2D.cast_to = end_pos



func _process(delta):
	set_point_position(0, start_pos)
	set_point_position(1, end_pos)



func _physics_process(delta):
	if $RayCast2D.is_colliding():
		var collision_point_world = $RayCast2D.get_collision_point()
		var collision_point = get_parent().transform.xform_inv(collision_point_world) - position
		print($RayCast2D.get_collider().name)
		var collision_normal = $RayCast2D.get_collision_normal()
		end_pos = collision_point
		make_laser()
		next_laser.visible = true
		next_laser.rotation_degrees = 90
		next_laser.position = collision_point
	else:
		end_pos = start_pos
		end_pos.y -= laser_distance
		if next_laser != null:
			next_laser.visible = false



func make_laser():
	if next_laser == null:
		var new_laser = laser_scene.instance()
		new_laser.laser_root_source = laser_root_source
		laser_root_source.add_child(new_laser)
		next_laser = new_laser

