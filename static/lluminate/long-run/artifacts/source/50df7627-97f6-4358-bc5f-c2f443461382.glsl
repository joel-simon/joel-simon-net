precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// This function creates winding, branch-like structures to represent organic growth.
// It replaces a common digital glitch grid (symbol of rigid technology) with a tree branch (subject) 
// where organic growth (trait: nurturance) is essential.
vec3 organicTree(vec2 pos) {
    // Distort position with time and fbm for branch meandering
    vec2 t_pos = pos;
    t_pos.y += 0.3 * sin(time + t_pos.x * 10.0);
    float branches = fbm(t_pos * 5.0 + time * 0.5);
    
    // Create branch outlines with smooth steps
    float branchShape = smoothstep(0.45, 0.5, abs(fract(pos.x * 10.0 + branches) - 0.5));
    
    // Color varies with vertical position and branch complexity
    vec3 branchColor = mix(vec3(0.2, 0.1, 0.0), vec3(0.0, 0.5, 0.1), pos.y + 0.5);
    return branchColor * branchShape;
}

void main() {
    // Center uv coordinates
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Space A: Organic swirling fractal field (evoking natural ambiance)
    vec2 warped = pos;
    float angle = time * 0.5;
    float s = sin(angle), c = cos(angle);
    warped = vec2(c * warped.x - s * warped.y, s * warped.x + c * warped.y);
    float swirl = fbm(warped * 2.0 + time);
    float radius = length(pos);
    float vortex = smoothstep(0.5, 0.0, abs(sin(6.2831*(radius - swirl))));
    vec3 organicField = vec3(0.1 + 0.9 * swirl, 0.2 + 0.8 * vortex, 0.5 + 0.5 * sin(time + radius * 3.14));
    
    // Space B: Reimagined tree branch organic pattern (replacing digital glitch grid)
    vec3 treeBranches = organicTree(uv * 2.0 - 1.0);
    
    // Blend the two spaces: the organic field embodies swirling, dynamic nature,
    // while the tree branches emphasize organic growth where nurturance is key.
    vec3 finalColor = mix(treeBranches, organicField, vortex);
    
    // Add occasional organic bursts of light to symbolize moments of vitality
    float burst = step(0.98, random(uv * time * 0.7)) * 0.2;
    finalColor += burst;
    
    gl_FragColor = vec4(finalColor, 1.0);
}