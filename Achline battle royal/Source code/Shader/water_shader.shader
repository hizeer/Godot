shader_type canvas_item;

uniform float taille = 10.0;
uniform sampler2D water : hint_black;
uniform sampler2D grid : hint_black;

void fragment(){
	vec2 titled_uv = UV * taille;
	vec2 waves_uv_offset;
	waves_uv_offset.x = cos(TIME+(titled_uv.x+titled_uv.y)*0.8);
	waves_uv_offset.y = sin(TIME+(titled_uv.x+titled_uv.y)*1.2);
	
	COLOR = texture(water,titled_uv+ waves_uv_offset*0.1)-texture(grid,titled_uv)*-0.5;
}