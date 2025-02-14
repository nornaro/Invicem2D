extends Line2D

var ellipse_points = [
	Vector2(0.0, -44.8769), Vector2(3.0711, -44.1162), Vector2(6.1256, -42.7534),
	Vector2(9.1373, -40.8485), Vector2(12.0703, -38.4683), Vector2(14.8895, -35.6709),
	Vector2(17.5515, -32.5124), Vector2(20.0148, -28.9599), Vector2(22.2439, -25.0608),
	Vector2(24.1972, -20.8615), Vector2(25.8368, -16.4095), Vector2(27.1298, -11.7532),
	Vector2(28.0489, -6.9439), Vector2(28.5719, -2.0355), Vector2(28.6819, 2.9294),
	Vector2(28.3753, 7.9024), Vector2(27.6614, 12.7863), Vector2(26.5615, 17.4871),
	Vector2(25.1061, 21.9139), Vector2(23.3212, 26.0009), Vector2(21.2337, 29.6939),
	Vector2(18.8729, 33.0309), Vector2(16.2685, 36.0237), Vector2(13.4527, 38.6753),
	Vector2(10.4577, 40.9568), Vector2(7.3175, 42.7499), Vector2(4.0665, 44.0663),
	Vector2(0.7429, 44.9022), Vector2(-2.5874, 45.2669), Vector2(-5.8695, 45.1727),
	Vector2(-8.9515, 44.6167), Vector2(-11.7075, 43.6107), Vector2(-14.0046, 42.1734),
	Vector2(-15.7195, 40.3107), Vector2(-16.7471, 38.0425), Vector2(-17.0035, 35.3926),
	Vector2(-16.4539, 32.3881), Vector2(-15.0707, 29.0615), Vector2(-12.8386, 25.4442),
	Vector2(-9.7408, 21.5862), Vector2(-5.7705, 17.5343), Vector2(-1.0146, 13.3349),
	Vector2(3.3424, 8.0313), Vector2(8.3009, 2.6662), Vector2(13.6585, -2.0387),
	Vector2(19.2779, -6.6162), Vector2(25.0198, -10.9862), Vector2(30.7405, -15.0731),
	Vector2(36.2959, -18.8024), Vector2(41.5386, -22.1221), Vector2(46.3206, -24.9881),
	Vector2(50.4845, -27.3847), Vector2(53.8955, -29.2942), Vector2(56.4158, -30.7055),
	Vector2(57.9159, -31.6125), Vector2(58.2849, -32.0268), Vector2(57.4386, -32.0364),
	Vector2(55.3158, -31.6461), Vector2(51.9138, -30.8294), Vector2(47.2575, -29.5593),
	Vector2(41.4142, -27.7843), Vector2(34.4667, -25.4091), Vector2(26.4981, -22.2982),
	Vector2(17.5895, -18.2205), Vector2(7.8253, -12.8799), Vector2(-2.0128, -7.0194),
	Vector2(-12.3195, -0.4767), Vector2(-23.1042, 7.7571), Vector2(-34.3545, 17.5743),
	Vector2(-46.0667, 28.1771), Vector2(-58.2132, 39.2213), Vector2(-70.7553, 50.4235)
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	points = ellipse_points
