shader_type canvas_item;
render_mode blend_mix;

uniform vec2 direction = vec2(0.0, 1.0);
uniform float speed_scale = 0.1;

void fragment() {
    vec2 move = UV + direction * TIME * speed_scale;
    COLOR = texture(TEXTURE, fract(move));
}
