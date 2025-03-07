precision mediump float;
varying vec2 uv;
uniform float time;

float vortex(vec2 p) {
    // Center the coordinate system
    vec2 pos = p - 0.5;
    // Convert to polar coordinates
    float r = length(pos);
    float angle = atan(pos.y, pos.x);

    // Medium association: a rotating vortex with rhythmic distortion
    float twist = sin(r * 10.0 - time * 2.0);
    float spiral = angle + twist * 0.5;
  
    // Create waves along the spiral arms
    float pattern = sin(spiral * 5.0 + time) * 0.5 + 0.5;
  
    // Contrast effect: diminish effect as radius increases, emphasizing center vitality
    float mask = smoothstep(0.4, 0.0, r);
    return pattern * mask;
}

void main() {
    // Create a dynamic, digital labyrinth background with a merging vortex concept
    vec2 p = uv;
  
    // Base background color shifting over time (subtle digital tones)
    vec3 bgColor = vec3(0.1 + 0.1 * sin(time + p.x * 10.0), 0.15 + 0.15 * cos(time + p.y * 10.0), 0.2 + 0.1 * sin(time));
  
    // Vortex pattern overlay: a swirling, modulated structure showcasing organized chaos
    float v = vortex(p);
  
    // Use a complementary color palette for the vortex: warm neon accents
    vec3 vortexColor = mix(vec3(0.9, 0.3, 0.3), vec3(0.9, 0.9, 0.3), v);
  
    // Blend the vortex pattern with the background using smooth transitions
    vec3 finalColor = mix(bgColor, vortexColor, smoothstep(0.3, 0.6, v));
  
    gl_FragColor = vec4(finalColor, 1.0);
}