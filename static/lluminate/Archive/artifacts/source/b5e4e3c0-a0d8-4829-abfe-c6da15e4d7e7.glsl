precision mediump float;
varying vec2 uv;
uniform float time;

void main(){
    // Center UV coordinates around (0,0)
    vec2 pos = uv - 0.5;
    
    // Rotate position based on time
    float angle = time * 0.8;
    float s = sin(angle);
    float c = cos(angle);
    pos = vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
    
    // Calculate radial distance and a twist effect
    float len = length(pos);
    float twist = sin(10.0 * len - time * 5.0);
    
    // Create a color pattern based on the radius and twist effect
    vec3 color = vec3(0.5 + 0.5 * twist, 0.5 + 0.5 * sin(twist + 0.5), 0.5 + 0.5 * cos(twist - 0.5));
    
    gl_FragColor = vec4(color, 1.0);
}