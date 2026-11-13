shader_type canvas_item;

uniform vec4 flash_color: source_color = vec4(1.0);
uniform float flash_amount: hint_range(0.0, 1.0) = 0.0;
uniform bool blinking = false;
uniform float blink_speed = 25.0;

void fragment() {
	vec4 base_color = texture(TEXTURE, UV) * COLOR;
	base_color.rgb = mix(base_color.rgb, flash_color.rgb, flash_amount);

	if (blinking) {
		base_color.a *= step(0.0, sin(TIME * blink_speed));
	}

	COLOR = base_color;
}
