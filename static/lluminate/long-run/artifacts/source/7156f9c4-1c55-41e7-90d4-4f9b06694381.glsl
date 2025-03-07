precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

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

vec2 glitch(vec2 p) {
    float n = noise(vec2(p.y * 15.0, time * 0.8));
    return p + vec2(n * 0.08, 0.0);
}

vec2 swirl(vec2 pos, float amt) {
    float angle = amt * length(pos);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
}

float treeBranch(vec2 pos, float t) {
    pos = pos * 2.0 - 1.0;
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    float wave = sin(10.0 * r - a * 4.0 + t * 2.0);
    float trunk = exp(-10.0 * r);
    return smoothstep(0.2, 0.3, abs(wave) * trunk);
}

float organicPulse(vec2 pos) {
    float r = length(pos * 2.0 - 1.0);
    float pulse = smoothstep(0.3 + 0.1 * sin(time + r * 20.0), 
                              0.31 + 0.1 * sin(time + r * 20.0), r);
    return pulse;
}

float digitalWave(vec2 p) {
    float w = sin(p.x * 6.2831 + time) * 0.1;
    w += sin(p.x * 12.5662 - time * 1.5) * 0.05;
    w += (noise(p * 8.0 + time) - 0.5) * 0.08;
    return 0.5 + w;
}

void main(void) {
    // Apply glitch distortion to base coordinates
    vec2 p = glitch(uv);
    
    // Create a digital ocean wave pattern
    float waveValue = digitalWave(p * 3.0);
    float oceanMask = step(p.y, waveValue);
    
    // Apply swirling effect to create organic distortion
    vec2 swirledPos = swirl(uv - 0.5, 3.0 * sin(time * 0.8));
    swirledPos += 0.5;
    
    // Generate tree branch patterns from regular and swirled coordinates
    float branch1 = treeBranch(uv, time);
    float branch2 = treeBranch(swirledPos, time * 0.9);
    float branchPattern = mix(branch1, branch2, 0.5);
    
    // Add layered noise for organic texture
    float layerNoise = noise(uv * 5.0 + time) * 0.2;
    
    // Cosmic background blend based on distance from center
    vec2 centered = (uv - 0.5) * 2.0;
    float radius = length(centered);
    vec3 cosmicColor = mix(vec3(0.1, 0.15, 0.3), vec3(0.05, 0.1, 0.25), radius);
    
    // Digital ocean color with glitch stripes
    float glitchStripes = abs(sin((uv.y + time * 3.0) * 40.0));
    float glitchEffect = smoothstep(0.4, 0.45, glitchStripes);
    vec3 oceanColor = mix(vec3(0.02, 0.05, 0.2), vec3(0.0, 0.4, 0.5), glitchEffect);
    
    // Organic tree color from branch patterns
    vec3 treeColor = mix(vec3(0.4, 0.25, 0.1), vec3(0.1, 0.8, 0.3), branchPattern);
    
    // Dynamic gradient with warm and cool hues shifting with time and angle
    float angle = atan(uv.y - 0.5, uv.x - 0.5);
    vec3 warmColor = vec3(1.0, 0.4, 0.2);
    vec3 coolColor = vec3(0.2, 0.5, 1.0);
    vec3 gradient = mix(warmColor, coolColor, (sin(angle + time) + 1.0) * 0.5);
    
    // Combine cosmic background with digital ocean stripes
    vec3 baseColor = mix(cosmicColor, oceanColor, oceanMask);
    
    // Introduce organic pulse effect
    float pulse = organicPulse(uv);
    
    // Merge various elements: background, gradient, tree, noise and pulse
    vec3 finalColor = mix(baseColor, treeColor, smoothstep(0.15, 0.35, branchPattern + layerNoise));
    finalColor += gradient * pulse * 0.2;
    
    // Subtle glitch overlay to emphasize digital artifact
    finalColor += vec3(noise(vec2(uv.y * 10.0, time)) * 0.1);
    
    gl_FragColor = vec4(finalColor, 1.0);
}