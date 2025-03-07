precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(13.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float branchPattern(vec2 pos, float intensity) {
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    float branch = sin(8.0 * angle + time * 2.0) * cos(3.0 * radius - time);
    return smoothstep(0.2, 0.25, abs(branch)) * intensity;
}

void main() {
    // Remap uv to centered coordinates and stretch horizontally a bit
    vec2 pos = uv * 2.0 - 1.0;
    pos.x *= 1.2;
    
    // Convert to polar coordinates
    float r = length(pos);
    float theta = atan(pos.y, pos.x);
    
    // Core wave, symbolizing connectivity as a digital stream
    float coreStream = sin(10.0 * r - time * 3.0 + 4.0 * theta);
    
    // Add persistent, branching patterns representing resilient network of roots
    float branches = branchPattern(pos, 0.5);
    
    // Incorporate digital noise to resemble glitches that enhance connectivity
    float digitalNoise = noise(pos * 3.0 + time);
    float glitch = step(0.8, random(vec2(time, pos.y))) * 0.3;
    
    // Combine features: The connectivity of digital stream is essential for the network
    float combined = coreStream + branches + digitalNoise + glitch;
    
    // Color schemes: base is a cool digital cyan transitioning to warm amber for network flow
    vec3 colorDigital = vec3(0.0, 0.8, 0.9);
    vec3 colorOrganic = vec3(0.9, 0.6, 0.2);
    vec3 colorMix = mix(colorDigital, colorOrganic, smoothstep(0.0, 1.0, r));
    
    // Enhance with rhythmic intensity based on combined score
    float intensity = smoothstep(0.3, 0.5, combined) - smoothstep(0.7, 0.8, combined);
    vec3 finalColor = colorMix * intensity;
    
    // Apply a subtle vignette for depth
    float vignette = smoothstep(0.9, 0.3, r);
    finalColor *= vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}