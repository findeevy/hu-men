shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

// Number of color levels (2-256)
uniform int color_levels : hint_range(2, 256) = 8;
// Dither pattern scale
uniform float dither_scale : hint_range(0.5, 4.0) = 1.0;
// Dither intensity
uniform float intensity : hint_range(0.0, 1.0) = 1.0;

// Floyd-Steinberg diffusion weights
const vec3 weights = vec3(7.0, 3.0, 5.0) / 16.0;

void fragment() {
    // Get screen texture
    vec3 col = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;

    // Get pixel position
    vec2 pixel_pos = FRAGCOORD.xy * dither_scale;
    ivec2 ipos = ivec2(pixel_pos);

    // Calculate quantization levels
    float levels = float(color_levels - 1);

    // Sample neighbor pixels
    vec2 pixel_size = SCREEN_PIXEL_SIZE;
    vec3 neighbor_right = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(pixel_size.x, 0.0)).rgb;
    vec3 neighbor_down = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, pixel_size.y)).rgb;
    vec3 neighbor_diag = texture(SCREEN_TEXTURE, SCREEN_UV + pixel_size).rgb;

    // Calculate quantization error
    vec3 quantized = round(col * levels) / levels;
    vec3 error = col - quantized;

    // Distribute error to neighbors
    vec3 error_col = quantized;
    error_col += error * weights.x * intensity;           // Right neighbor contribution
    error_col += neighbor_right * weights.y * intensity;  // Down neighbor contribution
    error_col += neighbor_down * weights.z * intensity;   // Diagonal neighbor contribution

    // Apply final quantization
    vec3 final = round(error_col * levels) / levels;

    // Apply dither pattern to reduce banding
    float pattern = fract(sin(dot(pixel_pos, vec2(12.9898, 78.233))) * 43758.5453);
    final += (pattern - 0.5) * (1.0 / levels) * intensity;

    COLOR = vec4(final, 1.0);
}