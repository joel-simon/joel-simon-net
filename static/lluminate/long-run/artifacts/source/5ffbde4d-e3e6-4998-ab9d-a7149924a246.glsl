precision mediump float;
varying vec2 uv;
uniform float time;

//
// Random directive: "Honor thy error as a hidden intention"
//

// Random generator
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// Basic noise function
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

// Fractal Brownian Motion
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

// Digital Grid effect with glitch bursts
vec3 digitalGrid(vec2 pos) {
    vec2 gridUV = fract(pos * 20.0);
    float line = smoothstep(0.0, 0.03, gridUV.x) + smoothstep(1.0, 0.97, gridUV.x)
               + smoothstep(0.0, 0.03, gridUV.y) + smoothstep(1.0, 0.97, gridUV.y);
    float glitch = step(0.98, random(pos + time));
    vec3 color = mix(vec3(0.0), vec3(0.7, 0.3, 0.9), line * 0.5 + glitch * 0.5);
    return color;
}

// Tree shape function inspired by organic growth
float treeShape(vec2 p) {
    // Center coordinates and scale
    vec2 pos = (p - 0.5) * 2.0;
    
    // Trunk: vertical line with thickness attenuated by x
    float trunk = smoothstep(0.02, 0.0, abs(pos.x));
    
    // Branch oscillation: create branch offsets modulated with sine and time
    float branch = smoothstep(0.04, 0.0, abs(pos.x - 0.3 * sin(8.0 * pos.y + time)));
    
    // Combine trunk and branch
    float shape = max(trunk, branch);
    
    // Fade out top region to mimic leaves
    shape *= smoothstep(0.1, -0.5, pos.y);
    return shape;
}

void main() {
    // Base position and rotated coordinates for swirling effect
    vec2 pos = (uv - 0.5) * 2.0;
    float angle = time * 0.5;
    float s = sin(angle);
    float c = cos(angle);
    vec2 rotated = vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);

    // Fractal swirling field
    float swirl = fbm(rotated * 2.0 + time);
    float radius = length(pos);
    float vortex = smoothstep(0.5, 0.0, abs(sin(6.2831 * (radius - swirl))));

    // Compute digital grid with glitch effects
    vec3 gridColor = digitalGrid(uv + vec2(time * 0.1));
    
    // Compute organic colors from fbm noise and oscillatory sine based on radius
    vec3 organicColor = vec3(0.3 + 0.7 * fbm(pos * 3.0 + time),
                             0.4 + 0.6 * swirl,
                             0.5 + 0.5 * sin(time + radius * 3.14));
                             
    // Mix grid and organic swirling effect with vortex as blending factor
    vec3 mixedColor = mix(gridColor, organicColor, vortex);
    
    // Apply tree shape mask for an organic core element
    float tree = treeShape(uv);
    vec3 trunkColor = vec3(0.4, 0.25, 0.1);
    vec3 leafColor = vec3(0.2, 0.7, 0.3);
    // Blending factor based on vertical position simulating leaf canopy on top of trunk
    float leafBlend = smoothstep(0.45, 0.8, uv.y);
    vec3 treeColor = mix(trunkColor, leafColor, leafBlend);
    
    // Composite tree shape on swirl background driven by digital grid texture
    vec3 finalColor = mix(mixedColor, treeColor, tree);
    
    // Extra glitch bursts
    float burst = step(0.97, random(uv * time * 0.3)) * 0.2;
    finalColor += vec3(burst);
    
    gl_FragColor = vec4(finalColor, 1.0);
}