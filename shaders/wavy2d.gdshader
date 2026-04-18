shader_type canvas_item;

// Amount of horizontal movement (in pixels)
uniform float sway_amount : hint_range(0, 10) = 1.5;
// Wave frequency (higher = more waves)
uniform float frequency = 4.0;
// Wave speed multiplier
uniform float speed = 1.5;
// Vertical intensity (higher = more top movement)
uniform float vertical_intensity = 1.2;

void fragment() {
    // Calculate sway effect
    float wave = sin(UV.y * frequency + TIME * speed);
    float curve = (1.0 - UV.y) * vertical_intensity;

    // Calculate UV distortion
    vec2 distorted_uv = UV;
    distorted_uv.x += wave * curve * sway_amount * TEXTURE_PIXEL_SIZE.x;

    // Apply texture with distortion
    vec4 color = texture(TEXTURE, distorted_uv);
    COLOR = color;
}