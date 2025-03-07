precision mediump float;
varying vec2 uv;
uniform float time;

float noise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    // Domain fusion: Industrial gears meet organic coral reefs.
    vec2 pos = uv;
    vec2 center = vec2(0.5, 0.5);
    vec2 diff = pos - center;
    float r = length(diff);
    float angle = atan(diff.y, diff.x);
    
    // Mechanical gears: Create a sawtooth-like oscillation from angular data.
    float gear = abs(sin(10.0 * angle + time));
    
    // Organic coral: Use noise to simulate fractal organic growth.
    float coral = noise(diff * 15.0 + time);
    
    // Map radial factor to blend the two domains:
    float blendFactor = smoothstep(0.2, 0.6, r);
    float pattern = mix(gear, coral, blendFactor);
    
    // Introduce a digital glitch twist to merge digital disruption.
    vec2 twistedPos = pos + 0.08 * vec2(sin(time + pos.y * 20.0), cos(time + pos.x * 20.0));
    float glitch = noise(twistedPos * 25.0 - time);
    
    // Synthesize striking colors: industrial rust meets vibrant sea-teal.
    vec3 rust = vec3(0.8, 0.3, 0.2);
    vec3 teal = vec3(0.2, 0.7, 0.6);
    vec3 color = mix(rust, teal, pattern);
    
    // Modulate with glitch and spatial fade from center
    color += glitch * 0.15;
    color *= smoothstep(0.9, 0.0, r);
    
    gl_FragColor = vec4(color, 1.0);
}