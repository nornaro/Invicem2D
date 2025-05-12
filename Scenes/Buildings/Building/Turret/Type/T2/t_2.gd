extends Line2D

func _ready() -> void:
	# Step 1: Find the center of the points
	var center:Vector2 = Vector2()
	for point:Vector2 in points:
		center += point
	center /= points.size()

	# Step 2: Scale each point 20% closer to the center
	var scaled_points:Array = []
	for point in points:
		var scaled_point:Vector2 = center + 0.6 * (point - center)
		scaled_points.append(scaled_point)

	# Step 3: Translate each point by (-15, -50)
	var translated_points:Array = []
	for point:Vector2 in scaled_points:
		var translated_point:Vector2 = point + Vector2(-15, -50)
		translated_points.append(translated_point)
	points = translated_points
