shader_type canvas_item;

// Top wave cutoff settings
uniform float wave_height : hint_range(0.0, 0.2) = 0.06;
uniform float wave_frequency : hint_range(1.0, 15.0) = 5.0;
uniform float wave_speed : hint_range(0.1, 3.0) = 1.5;
uniform float edge_fade : hint_range(0.01, 0.2) = 0.08;

// Optional subtle animation for water texture
uniform float texture_wave_strength : hint_range(0.0, 0.005) = 0.005;
uniform float animation_speed : hint_range(0.1, 3.0) = 1.0;

// Use screen position for seamless waves across tiles
void fragment() {
    vec2 uv = UV;
    float time = TIME * animation_speed;
    
    // Subtle vertical wave animation (up and down motion)
    float tex_wave = sin(SCREEN_UV.x * 30.0 + time * 2.0) * texture_wave_strength;
    vec2 animated_uv = vec2(uv.x, uv.y + tex_wave);
    
    // Sample the water texture
    vec4 color = texture(TEXTURE, animated_uv);
    
    // Create wavy top edge using screen position for seamless effect
    float wave_offset = sin(SCREEN_UV.x * wave_frequency + TIME * wave_speed) * wave_height;
    float mask = smoothstep(wave_offset - edge_fade, wave_offset, uv.y);
    
    // Apply the mask to alpha channel for top cutoff
    color.a *= mask;
    
    COLOR = color;
}
