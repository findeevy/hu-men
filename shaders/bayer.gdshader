shader_type canvas_item;

// Dithering intensity (0.0 - 1.0)
uniform float dither_intensity : hint_range(0.0, 1.0) = 1.0;
// Color reduction levels (2-256)
uniform int color_levels : hint_range(2, 256) = 4;

// 4x4 Bayer matrix for dithering
const float[16] bayer_matrix = float[](
    0.0,  8.0,  2.0,  10.0,
    12.0, 4.0,  14.0, 6.0,
    3.0,  11.0, 1.0,  9.0,
    15.0, 7.0,  13.0, 5.0
);

void fragment() {
    // Sample original texture color
    vec4 color = texture(TEXTURE, UV);

    // Calculate pixel position in screen space
    vec2 pixel_pos = floor(FRAGCOORD.xy);

    // Get Bayer matrix index (0-15)
    int matrix_x = int(mod(pixel_pos.x, 4.0));
    int matrix_y = int(mod(pixel_pos.y, 4.0));
    int bayer_index = matrix_x + matrix_y * 4;

    // Get Bayer threshold value (0-15) and normalize to 0-1 range
    float threshold = bayer_matrix[bayer_index] / 16.0;

    // Apply dithering to each color channel
    float levels = float(color_levels - 1);

    color.r = floor(color.r * levels + threshold * dither_intensity) / levels;
    color.g = floor(color.g * levels + threshold * dither_intensity) / levels;
    color.b = floor(color.b * levels + threshold * dither_intensity) / levels;

    COLOR = color;
}