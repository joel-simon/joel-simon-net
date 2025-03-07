precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo random function
float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Function to rotate a 2D point by an angle
vec2 rotate(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

// Drawing a gear shape using polar coordinates
float gear(vec2 pos, float t) {
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    float spikes = 8.0;
    float gearShape = abs(sin(spikes * angle + t));
    return smoothstep(gearShape * 0.3, gearShape * 0.3 + 0.02, radius);
}

// Drawing a ripple ocean effect inspired function
float ripple(vec2 pos, float t) {
    float dist = length(pos);
    float rippleEffect = sin(10.0 * dist - t * 4.0);
    float twist = cos(atan(pos.y, pos.x) * 3.0 + t) * 0.5;
    return smoothstep(0.45 + twist, 0.4 + twist, dist + rippleEffect * 0.05);
}

// Drawing organic tree branch style structure
float tree(vec2 pos, float t) {
    pos.y += 0.5;
    float branch = smoothstep(0.02, 0.0, abs(pos.x - 0.2 * sin(pos.y * 12.0 + t * 3.0)));
    branch += smoothstep(0.02, 0.0, abs(pos.x + 0.2 * sin(pos.y * 10.0 + t * 2.5)));
    branch += (pseudoRandom(pos * (t + 1.0)) - 0.5) * 0.1;
    return branch;
}

void main(void) {
    // Transform uv to [-1,1] space
    vec2 pos = uv * 2.0 - 1.0;
    
    // Create two conceptual domains
    // Domain 1: Mechanical Cosmos (gear pattern blended with ocean ripple)
    vec2 mechPos = rotate(pos, time * 0.5);
    float gearPattern = gear(mechPos, time);
    float oceanBase = ripple(pos, time);
    float mechanical = mix(gearPattern, oceanBase, 0.5);
    
    // Domain 2: Organic Growth (tree branch structure)
    float organic = tree(pos, time);
    
    // Blend domains selectively based on horizontal coordinate
    float blendFactor = smoothstep(-0.2, 0.2, pos.x);
    float pattern = mix(mechanical, organic, blendFactor);
    
    // Define colors for each domain:
    // Mechanical domain: cool cosmic colors
    vec3 mechColor = mix(vec3(0.5, 0.6, 0.8), vec3(0.0, 0.1, 0.3), mechanical);
    // Organic domain: earthy and warm, hinting at growth
    vec3 organColor = mix(vec3(0.4, 0.3, 0.1), vec3(0.2, 0.1, 0.0), organic);
    vec3 color = mix(mechColor, organColor, blendFactor);

    // Modulate brightness by pattern strength and add emergent shimmer
    float shimmer = smoothstep(0.0, 0.02, abs(fract(length(pos) * 15.0 - time * 2.5) - 0.5));
    color *= (smoothstep(0.3, 0.0, abs(pattern - 0.5)) + 0.5);
    color += shimmer * 0.2;
    
    gl_FragColor = vec4(color, 1.0);
}