shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float opacity : hint_range(0.0, 1.0) = 0.7;

void fragment() {
    vec4 color = texture(screen_texture, SCREEN_UV);

    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));

    COLOR = vec4(gray, 0.0, 0.0, color.a*opacity);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
