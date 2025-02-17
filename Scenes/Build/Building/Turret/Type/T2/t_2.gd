extends Line2D

func _ready():
	# Step 1: Find the center of the points
	var center = Vector2()
	for point in points:
		center += point
	center /= points.size()

	# Step 2: Scale each point 20% closer to the center
	var scaled_points = []
	for point in points:
		var scaled_point = center + 0.6 * (point - center)
		scaled_points.append(scaled_point)

	# Step 3: Translate each point by (-15, -50)
	var translated_points = []
	for point in scaled_points:
		var translated_point = point + Vector2(-15, -50)
		translated_points.append(translated_point)
	points = translated_points
