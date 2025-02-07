extends RigidBody2D

# Ballistic parameters
var Data = {}  # Make sure Data is properly initialized with Upgrades and ProjectileSpeed
var gravity = 9.8  # m/s²
var target = null
var t
var y
var threshold = -100
var out = false
var previous_velocity_y = 0  # To track the previous vertical velocity

func _ready():
	
	$Area2D.collide = false
	
	# Calculate direction towards target
	var direction = target.global_position - global_position
	var distance_to_target = direction.length()
	var velocity_multiplier = 1 + 100 / distance_to_target  # Increase velocity based on closeness to target
	var initial_velocity = 50 * (Data.Upgrades.ProjectileSpeed + 10) * velocity_multiplier  # Adjusted velocity

	# Normalize direction to get the unit vector for correct direction
	direction = direction.normalized()
	
	# Set velocity based on target direction
	linear_velocity = direction * initial_velocity
	
	y = global_position.y
	t = target.global_position
	previous_velocity_y = linear_velocity.y  # Store the initial vertical velocity

func _physics_process(delta):
	threshold += 10
	# Check if the vertical velocity changes direction (upward to downward)
	if sign(previous_velocity_y) + sign(linear_velocity.y) == 0:
		out = true
	
	# Store the current velocity to check for changes in direction
	previous_velocity_y = linear_velocity.y
	
	# Threshold for enabling collision
	if global_position.y - t.y < 10 and out:
		print(threshold, "  ",t.y," - ",global_position.y)
		#print("collides: ",threshold)
		$Area2D.collide = true
	
	# Free the projectile if it moves past the target
	if global_position.y > t.y and out:
		queue_free()

func _on_area_2d_area_entered(area):
	if !area.get_parent().is_in_group("minions"):
		return
	queue_free()
	area.get_parent().hurt(Data.Upgrades.Damage, Data.Upgrades.Penetration)
	
