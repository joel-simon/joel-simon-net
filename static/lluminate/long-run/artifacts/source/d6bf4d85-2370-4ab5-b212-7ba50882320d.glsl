precision mediump float;
varying vec2 uv;
uniform float time;

float invertedStructure(vec2 p) {
    // Center coordinates and mirror vertically for an inverted effect
    p = (p - 0.5) * 2.0;
    p.y = -p.y;
    
    // Base stem: using a narrow bar that widens with a sinusoidal ripple
    float stem = smoothstep(0.2, 0.0, abs(p.x) - 0.03 * sin(5.0 * p.y + time));
    
    // Instead of branches going upward, use a swirling vortex at the bottom
    vec2 vortex = p - vec2(0.0, -0.5);
    float angle = atan(vortex.y, vortex.x);
    float radius = length(vortex);
    float swirl = smoothstep(0.5, 0.0, radius) * abs(sin(angle * 4.0 + time));
    
    // Combine the vertical stem and vortex elements
    return max(stem, swirl);
}

void main() {
    vec2 p = uv;
    
    // Background: reversed luminance gradient - bright at edges, dark at center
    float d = length(p - vec2(0.5));
    vec3 edgeColor = vec3(1.0, 0.95, 0.8);
    vec3 centerColor = vec3(0.1, 0.1, 0.15);
    vec3 bgColor = mix(centerColor, edgeColor, smoothstep(0.0, 0.8, d));
    
    // Generate the inverted structure
    float structure = invertedStructure(p);
    
    // Colors for the structure: a cool palette with ephemeral blue and hints of violet
    vec3 coolColor = vec3(0.2, 0.4, 0.8);
    vec3 flairColor = vec3(0.6, 0.2, 0.7);
    float blendFactor = smoothstep(0.0, 1.0, uv.y);
    vec3 structureColor = mix(coolColor, flairColor, blendFactor);
    
    // Composite the structure with the reversed background; use parabolic blending for a smooth integration.
    vec3 finalColor = mix(bgColor, structureColor, pow(structure, 0.5));
    
    gl_FragColor = vec4(finalColor, 1.0);
}