shader_type canvas_item;

uniform vec4 color: source_color;
uniform int draw_mode = 0xff;
uniform int grid_x = 32;
uniform int grid_y = 32;
uniform float angle_step = 22.5;

uniform float scale = 1.0;
uniform vec2 offset = vec2(200.0, 200.0);
uniform float thickness = 0.06;

uniform vec4 select_color : source_color;
uniform float select_t = 2.0;
uniform vec2 select_beg = vec2(0, 0);
uniform vec2 select_end = vec2(0, 0);


void fragment() {
	vec2 pos = vec2(FRAGCOORD.x, FRAGCOORD.y);
	pos = (pos - offset)*scale;
	vec2 grid_p = pos;
	grid_p.x /= float(grid_x);
	grid_p.y /= float(grid_y);
	
	float c_dist = abs(fract(length(grid_p) + 0.5) - 0.5);
	vec2 g_dist = abs(fract(grid_p + vec2(0.5)) - vec2(0.5));
	float p_dist = abs(fract(180.0/PI/angle_step*atan(grid_p.y, grid_p.x) + 0.5) - 0.5);
	p_dist *= length(grid_p)*pow(180.0/angle_step, 0.25)/90.0*angle_step;
	
	float draw_val = 1.0;
	draw_val = min(draw_val, float(1 - (draw_mode >> 0 & 1)) + g_dist.x);
	draw_val = min(draw_val, float(1 - (draw_mode >> 1 & 1)) + g_dist.y);
	draw_val = min(draw_val, float(1 - (draw_mode >> 2 & 1)) + c_dist);
	draw_val = min(draw_val, float(1 - (draw_mode >> 3 & 1)) + p_dist);
	
	float t = thickness*scale/float(grid_x)*32.0;
	float v = max(0.0, 1.0 - draw_val/t);
	v = smoothstep(0, 1.0, v);
	
	float main_axes = max(0.0, thickness - min(abs(grid_p.x), abs(grid_p.y)));
	
	vec4 grid_col = vec4(color.rgb, color.a*v + 4.0*main_axes);
	
	float select_x = step(select_beg.x, pos.x);
	select_x -= step(select_end.x, pos.x);
	float select_inner_x = step(select_beg.x + select_t, pos.x);
	select_inner_x -= step(select_end.x - select_t, pos.x);
	float select_y = step(select_beg.y, pos.y);
	select_y -= step(select_end.y, pos.y);
	float select_inner_y = step(select_beg.y + select_t, pos.y);
	select_inner_y -= step(select_end.y - select_t, pos.y);
	
	float select = max(0.0, min(select_x, select_y) - 0.4*(min(select_inner_x, select_inner_y)));
	select *= step(4.0, abs(select_beg.x - select_end.x));
	select *= step(4.0, abs(select_beg.y - select_end.y));
	
	COLOR = mix(grid_col, select_color, select);
}
