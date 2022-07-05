
shader_type canvas_item;
uniform float scroll_speed_x;
uniform float scroll_speed_y;
uniform float background_distance_x;
uniform float background_distance_y;

void fragment(){
    vec2 shifteduv = UV;
    shifteduv .x += background_distance_x * scroll_speed_x;
	shifteduv .y += background_distance_y * scroll_speed_y;
    vec4 color = texture(TEXTURE, shifteduv);
    COLOR = color;
}
