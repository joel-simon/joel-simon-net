precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void main() {
    // draw_random_card: "Honor thy error as a hidden intention."
    // interpret_directive: Introduce a deliberate glitch/error into the flow.
    // apply_insight: Modify coordinates with a pseudo-random offset, mimicking a hidden intention in a glitch.
    
    // Center uv coordinates and scale so center is 0,0
    vec2 pos = uv * 2.0 - 1.0;
    
    // Introduce a pseudo-random glitch offset based on time and uv
    float glitch = random(uv + time * 0.5);
    vec2 offset = vec2(sin(time + glitch * 6.28), cos(time + glitch * 6.28)) * 0.1;
    pos += offset;
    
    // Polar coordinates for swirling effect
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Create a wave pattern that combines radial distortion and angular oscillations
    float wave = sin(12.0 * radius - time * 3.0 + angle * 8.0);
    
    // Color base altered with a glitchy offset influence 
    vec3 baseColor = vec3(0.5 + 0.5 * sin(pos.xyx * 4.0 + time));
    baseColor += vec3(glitch * 0.3, glitch * 0.15, glitch * 0.5);
    
    // Final color blending wave and glitch effects
    vec3 color = baseColor * (0.5 + 0.5 * wave);
    
    gl_FragColor = vec4(color, 1.0);
}