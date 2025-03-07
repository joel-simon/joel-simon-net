precision mediump float;
varying vec2 uv;
uniform float time;

// A pseudo-random function for noise and glitch effects
float rand(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    // Directive: "Honor thy error as a hidden intention."
    // We interpret this as embracing deliberate glitches and imperfections.
    
    vec2 pos = uv;
    
    // Introduce a subtle zoom that pulsates with time
    pos = (pos - 0.5) * (1.0 + 0.2 * sin(time * 0.8)) + 0.5;
    
    // Create a glitch effect by distorting the UV coordinates based on random stripes
    float lineGlitch = step(0.95, rand(vec2(floor(pos.y * 50.0), time)));
    pos.x += lineGlitch * (rand(pos * 100.0 + time) - 0.5) * 0.1;
    
    // Digital error pattern mixing smooth sinusoidal stripes and noise
    float stripes = abs(sin(pos.x * 60.0 + time * 3.0));
    float noiseVal = rand(pos * 10.0 + time);
    float errorPattern = mix(stripes, noiseVal, 0.5);
    
    // Color interplay: using digital glitch hues with organic fluctuations
    vec3 color;
    color.r = smoothstep(0.2, 1.0, errorPattern + sin(time + pos.x * 10.0));
    color.g = smoothstep(0.1, 0.9, errorPattern + cos(time + pos.y * 10.0));
    color.b = smoothstep(0.3, 1.0, errorPattern);
    
    // Overlay a subtle film grain for extra texture
    float filmGrain = rand(pos * 200.0 + time);
    color += filmGrain * 0.05;
    
    gl_FragColor = vec4(color, 1.0);
}