shader_type canvas_item;
uniform vec4 blink_color: source_color;
uniform float blink_intensity = 0;

uniform bool damage_active = false;
uniform float damage_time : hint_range(0.0, 2.0) = 0.0;
uniform float shake_intensity : hint_range(0.0, 1.0) = 0.0;
uniform float distortion : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec2 uv = UV;
	vec4 color = texture(TEXTURE, UV);
	color = mix(color, blink_color, blink_intensity * color.a);

	if (damage_active) {
        float shake = shake_intensity * (sin(TIME * 40.0) * 0.03 + sin(TIME * 25.0) * 0.02);
        uv += vec2(shake, shake * 0.7);

        float wave = sin((uv.y + TIME * 12.0) * 20.0) * distortion * 0.015;
        uv.x += wave;

        vec3 damage_tint = vec3(
            1.0,
            0.1 + 0.2 * sin(TIME * 18.0),
            0.05 + 0.15 * sin(TIME * 22.0)
        );

        float pulse = damage_time * (0.9 + 0.3 * sin(TIME * 16.0));
        color.rgb = mix(color.rgb, damage_tint, pulse * 0.85);

        color.rgb *= 1.0 + pulse * 0.6 + sin(TIME * 30.0) * 0.2;

        float vignette = 1.0 - length(uv - 0.5) * 0.8;
        color.rgb *= vignette * 0.7 + 0.3;
    }

	COLOR = color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
