shader_type canvas_item;

uniform float opacity = 0;

void fragment() {
	COLOR.rgb = texture(TEXTURE, UV).rgb * (1.0 - opacity) + vec3(1,1,1) * opacity;
	COLOR.a = texture(TEXTURE, UV).a;
}
