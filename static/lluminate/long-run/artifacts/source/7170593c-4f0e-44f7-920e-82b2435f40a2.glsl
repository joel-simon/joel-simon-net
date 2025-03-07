precision mediump float;
varying vec2 uv;
uniform float time;

// A basic pseudo random function
float pseudoRandom(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Function to rotate a 2D point by an angle
vec2 rotate(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

// Draw a simple gear shape using polar coordinates
float gear(vec2 pos, float t) {
    // Convert to polar coordinates
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    
    // Create a gear effect with periodic spikes
    float spikes = 8.0;
    float gearShape = abs(sin(spikes * angle + t)) * 0.3;
    
    return smoothstep(gearShape, gearShape + 0.02, radius);
}

// Draw a tree branch structure using noise and sinusoidal functions
float tree(vec2 pos, float t) {
    // Map UV to a more tree-like coordinate system
    pos.y += 0.5;
    
    // Create branch lines with sin functions modulated by time
    float branch = smoothstep(0.02, 0.0, abs(pos.x - 0.2 * sin(pos.y * 12.0 + t * 3.0)));
    branch += smoothstep(0.02, 0.0, abs(pos.x + 0.2 * sin(pos.y * 10.0 + t * 2.5)));
    
    // Fuzziness for natural effect
    branch += (pseudoRandom(pos * (t + 1.0)) - 0.5) * 0.1;
    return branch;
}

void main() {
    // Normalize and center the coordinate system
    vec2 pos = uv * 2.0 - 1.0;
    
    // Create two domains: Mechanical Gear (left side) and Organic Tree (right side)
    // Split at x = 0.0
    float domainMix = smoothstep(-0.05, 0.05, pos.x);
    
    // Mechanical domain: gear-like pattern
    vec2 gearPos = pos;
    gearPos = rotate(gearPos, time * 0.5);
    float gearPattern = gear(gearPos, time);
    
    // Organic domain: tree branch pattern
    vec2 treePos = pos;
    treePos.x *= 1.0;
    float treePattern = tree(treePos, time);
    
    // Synthesize both domains:
    // Blend them based on horizontal coordinate mixing
    float pattern = mix(gearPattern, treePattern, domainMix);
    
    // Color synthesis:
    // For mechanical domain, use cool metallic colors; for organic, use warm earthy colors.
    vec3 mechColor = mix(vec3(0.3, 0.4, 0.5), vec3(0.6, 0.7, 0.8), gearPattern);
    vec3 organColor = mix(vec3(0.2, 0.1, 0.0), vec3(0.4, 0.3, 0.1), treePattern);
    vec3 color = mix(mechColor, organColor, domainMix);
    
    // Modulate brightness with pattern intensity
    color *= smoothstep(0.3, 0.0, abs(pattern - 0.5)) + 0.5;
    
    gl_FragColor = vec4(color, 1.0);
}