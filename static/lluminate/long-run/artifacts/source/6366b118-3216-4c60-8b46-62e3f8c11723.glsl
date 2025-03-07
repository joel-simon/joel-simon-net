precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for pseudo-randomness
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

// 2D noise based on hash
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Fractal Brownian Motion with 6 octaves
float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        total += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

// Reverse polar transform: from polar to cartesian with dynamic twist
vec2 polarToCart(vec2 polar) {
    float angle = polar.x;
    float r = polar.y;
    return vec2(cos(angle), sin(angle)) * r;
}

// Combine organic warp with glitch slices
vec2 glitchWarp(vec2 pos) {
    float glitchLine = step(0.5, fract(pos.y * 10.0 + time));
    float offset = noise(vec2(pos.y * 20.0, time)) * glitchLine * 0.1;
    pos.x += offset;
    return pos;
}

// Modify swirl based on an organic twist
vec2 organicSwirl(vec2 pos, float strength) {
    float r = length(pos);
    float theta = atan(pos.y, pos.x) + strength * exp(-r*2.0) * sin(time + r*10.0);
    return vec2(cos(theta), sin(theta)) * r;
}

void main(void) {
    // Map uv to centered coordinates [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Apply a glitch warp effect
    pos = glitchWarp(pos);
    
    // Convert to polar coordinates
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Use FBM to generate an organic field in the polar domain
    float organic = fbm(vec2(angle * 0.5 + time * 0.3, r * 3.0));
    
    // Modify polar coordinates with the organic field
    angle += 0.5 * (organic - 0.5);
    r *= 1.0 + 0.3 * sin(time + organic * 6.28);
    
    // Convert back to cartesian coordinates and apply swirl distortion
    vec2 newPos = organicSwirl(vec2(cos(angle), sin(angle)) * r, 3.0);
    
    // Generate color based on recombined coordinates and organic noise
    vec3 baseColor = mix(vec3(0.05, 0.2, 0.4), vec3(0.8, 0.2, 0.5), organic);
    vec3 overlay = vec3(sin(newPos.x * 10.0 + time), sin(newPos.y * 10.0 + time), cos((newPos.x+newPos.y) * 5.0));
    overlay = (overlay + 1.0) * 0.5;
    
    // Combine the layers to create a glitched organic look
    vec3 finalColor = mix(baseColor, overlay, 0.4);
    
    // Add subtle vignette effect
    float vignette = smoothstep(1.0, 0.2, length(pos));
    finalColor *= vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}