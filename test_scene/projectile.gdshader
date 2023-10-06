shader_type canvas_item;

uniform vec4 c1 : source_color;
uniform vec4 c2 : source_color;

void fragment() {
	//change 0.03 to 0.5 for cool effect
//	float r = length(UV - vec2(0.5)) + 0.03*sin(TIME*3.5 + 0.2*sin(UV.x*100.0) + 0.3*cos(UV.y*120.0));
	float r = length(UV - vec2(0.5));
	COLOR = mix(c1, c2, pow(r*3.0, 2.0));
	COLOR.a = smoothstep(0.4, 0.36, r);
}
