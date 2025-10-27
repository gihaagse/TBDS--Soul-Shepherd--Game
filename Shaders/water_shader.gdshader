shader_type canvas_item;

// Main water controls
uniform float wave_strength = 0.03;
uniform float wave_speed = 1.5;
uniform float wave_scale = 10.0;
uniform sampler2D water_texture;
uniform float water_opacity : hint_range(0, 1) = 0.7;

// Wavy top controls
uniform float top_wave_amplitude = 0.08;
uniform float top_wave_frequency = 6.0;

// Softness control for the top edge fade
uniform float top_edge_softness = 0.12;
uniform float top_edge_offset = 0.05;

// Godot 4 screen texture logic
uniform sampler2D screen_tex : hint_screen_texture;


void fragment() {
    vec2 uv = UV;
    float time = TIME * wave_speed;

    // Horizontal wave factor for animation
    float wave = sin(uv.x * wave_scale + time) * wave_strength;

    // Apply vertical wave distortion
    vec2 wave_uv = vec2(uv.x, uv.y + wave);

    vec4 water_col = texture(water_texture, wave_uv);

    // Screen refraction for a glassy look
    vec2 screen_uv = SCREEN_UV;
    float screen_wave = sin(screen_uv.x * wave_scale + time) * wave_strength;
    vec2 screen_wave_uv = vec2(screen_uv.x, screen_uv.y + screen_wave);
    vec4 screen_col = texture(screen_tex, screen_wave_uv);

    // Blend screen + water
    vec4 final_col = mix(screen_col, water_col, water_opacity);

    // --- Top edge sinusoidal mask with softness ---
    float top_wave = sin(uv.x * top_wave_frequency + time) * top_wave_amplitude;
    float mask_edge = smoothstep(top_edge_offset, top_edge_offset + top_edge_softness, uv.y - top_wave);
    // Apply the mask for wavy top (fade alpha at the top)
    final_col.a *= mask_edge;

    COLOR = final_col;
}
