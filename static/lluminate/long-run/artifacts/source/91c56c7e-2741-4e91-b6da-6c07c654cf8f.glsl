precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for pseudo-random noise.
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

// 2D noise function.
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0, 0.0)),
                   hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)),
                   hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

// Cybernetic circuit pattern
float circuit(vec2 pos, float t) {
    float grid = step(0.48, abs(fract(pos.x * 5.0 + t) - 0.5)) + 
                 step(0.48, abs(fract(pos.y * 5.0 + t) - 0.5));
    return smoothstep(0.0, 0.5, grid);
}

// Organic coral-like undulation.
float coral(vec2 pos, float t) {
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    float waves = sin(10.0 * radius - t * 2.0 + 3.0 * angle);
    return smoothstep(0.2, 0.4, waves);
}

// Combine underwater flowing currents with glitchy digital interference.
vec3 synthesize(vec2 pos, float t) {
    // Transform to polar coordinates.
    pos = pos * 2.0 - 1.0;
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    
    // Underwater current patterns.
    float current = sin(8.0 * radius - t*1.5 + angle*2.0);
    current = abs(current);
    
    // Circuit board interference.
    float digital = circuit(pos * 1.5, t);
    
    // Coral growth textures.
    float organic = coral(pos, t);
    organic = mix(organic, noise(pos * 6.0 + t), 0.3);
    
    // Synthesize the results:
    float mask = smoothstep(0.3, 0.5, radius);
    float combined = mix(current, digital, 0.5);
    combined = mix(combined, organic, 0.5);
    combined *= mask;
    
    // Color palette blending: underwater blue-green with neon magenta.
    vec3 colorA = vec3(0.0, 0.6, 0.7); // Underwater hue.
    vec3 colorB = vec3(0.8, 0.1, 0.5); // Circuit neon.
    
    return mix(colorA, colorB, combined);
}

void main(){
    // Base uv for effects.
    vec2 pos = uv;
    
    // Add subtle time-dependent noise swirl.
    float swirl = noise(pos * 3.0 + time * 0.7);
    pos += vec2(swirl * 0.03, swirl * 0.03);
    
    vec3 finalColor = synthesize(pos, time);
    
    // Varying brightness with a radial vignette.
    float vignette = smoothstep(1.0, 0.2, distance(uv, vec2(0.5)));
    finalColor *= vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}