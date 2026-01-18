shader_type canvas_item;

// Side wave settings
uniform float wave_width : hint_range(0.0, 0.2) = 0.06;
uniform float wave_frequency : hint_range(1.0, 15.0) = 5.0;
uniform float wave_speed : hint_range(0.1, 3.0) = 1.5;
uniform float edge_fade : hint_range(0.01, 0.2) = 0.08;

// Optional subtle animation for water texture
uniform float texture_wave_strength : hint_range(0.0, 0.002) = 0.002;
uniform float animation_speed : hint_range(0.1, 3.0) = 1.0;

varying vec2 world_pos;

void vertex() {
    // Calculate world position in vertex shader (camera-independent)
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
    vec2 uv = UV;
    float time = TIME * animation_speed;

    // Subtle horizontal wave animation using world position (left to right motion)
    float tex_wave = sin(world_pos.y * 0.3 + time * 2.0) * texture_wave_strength;
    vec2 animated_uv = vec2(uv.x + tex_wave, uv.y);

    // Sample the water texture
    vec4 color = texture(TEXTURE, animated_uv);

    // Create wavy side edge - now using Y position for horizontal waves
    float wave_offset = sin(world_pos.y * wave_frequency * 0.01 + TIME * wave_speed) * wave_width;
    float mask = smoothstep(wave_offset - edge_fade, wave_offset + edge_fade, uv.x);

    // Apply the mask to alpha channel for side cutoff
    color.a *= mask;

    COLOR = color;
}
