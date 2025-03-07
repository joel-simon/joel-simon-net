precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo random function for noise generation
float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233)))*43758.5453123);
}

// Function to rotate a 2D vector by a given angle
vec2 rotate(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

// Mechanical gear effect based on polar coordinates with spikes
float gear(vec2 pos, float t) {
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    float spikes = 8.0;
    float pattern = abs(sin(spikes * angle + t));
    float gearShape = smoothstep(pattern * 0.3, pattern * 0.3 + 0.02, radius);
    return gearShape;
}

// Organic tree branch structure using sinusoidal distortion and noise
float tree(vec2 pos, float t) {
    pos.y += 0.5; // Shift to create a trunk-like structure
    float branch1 = smoothstep(0.02, 0.0, abs(pos.x - 0.2 * sin(pos.y * 12.0 + t * 3.0)));
    float branch2 = smoothstep(0.02, 0.0, abs(pos.x + 0.2 * sin(pos.y * 10.0 + t * 2.5)));
    float noise = (pseudoRandom(pos * (t + 1.0)) - 0.5) * 0.1;
    return branch1 + branch2 + noise;
}

void main() {
    // Normalize coordinates to the range [-1, 1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Divide the screen into two domains: left mechanical, right organic
    float mixFactor = smoothstep(-0.05, 0.05, pos.x);
    
    // Mechanical gear effect: rotate and compute gear shape in left half
    vec2 mechPos = rotate(pos, time * 0.5);
    float mechPattern = gear(mechPos, time);
    
    // Organic tree branch effect for the right side
    vec2 organPos = pos;
    float organPattern = tree(organPos, time);
    
    // Combine both effects depending on horizontal position
    float combinedPattern = mix(mechPattern, organPattern, mixFactor);
    
    // Define colors for each domain; mechanical uses cool metallic hues,
    // organic uses warm earthy colors symbolizing growth
    vec3 mechColor = mix(vec3(0.3, 0.4, 0.5), vec3(0.6, 0.7, 0.8), mechPattern);
    vec3 organColor = mix(vec3(0.4, 0.25, 0.1), vec3(0.2, 0.6, 0.2), organPattern);
    
    // Blend the colors based on the domain mix factor
    vec3 color = mix(mechColor, organColor, mixFactor);
    
    // Highlight the composite by modulating brightness with the combined pattern
    color *= smoothstep(0.3, 0.0, abs(combinedPattern - 0.5)) + 0.5;
    
    gl_FragColor = vec4(color, 1.0);
}