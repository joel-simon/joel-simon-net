precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for pseudo-randomness
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 43758.5453123);
}

// 2D noise function with smooth interpolation
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

// Fractal brownian motion for deeper noise
float fbm(vec2 p) {
    float total = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 5; i++){
        total += noise(p) * amp;
        p *= 2.0;
        amp *= 0.5;
    }
    return total;
}

// Glitch function adds digital distortion
vec2 glitch(vec2 p, float t) {
    float shift = step(0.95, fract(sin(dot(p, vec2(12.345, 67.890)) + t*7.0))) * 0.1;
    return p + vec2(shift, 0.0);
}

// Generates error-like bands to mimic accidental design features
float errorBand(vec2 pos) {
    float band = sin(pos.y * 50.0 + time * 10.0);
    return smoothstep(0.02, 0.03, abs(band));
}

// Glitch offset using per-row random noise
vec2 glitchOffset(vec2 pos) {
    float offset = noise(vec2(floor(pos.y * 20.0), time));
    return vec2(offset * 0.05, 0.0);
}

void main(){
    // Transform uv to centered coordinates
    vec2 st = uv * 2.0 - 1.0;
    
    // Apply glitch distortion to simulate digital breakdown
    vec2 glitchPos = glitch(st, time);
    
    // Create an organic cosmic swirl by mixing polar coordinates with fractal noise
    float radius = length(glitchPos);
    float angle = atan(glitchPos.y, glitchPos.x);
    
    // Pulsating burst derived from organic branching interference
    float burst = abs(sin(10.0 * angle + time * 3.0));
    
    // Radial decay from the center gives organic aging effect
    float decay = smoothstep(0.5, 0.48, radius);
    
    // Use fractal noise to supply texture reminiscent of natural tree veins
    float organic = fbm(glitchPos * 3.0 + time * 0.3);
    
    // Add error bands for digital glitch accents by distorting uv further
    vec2 disturbed = st + glitchOffset(st);
    float bands = errorBand(disturbed);
    
    // Synthesize color effects by blending digital and organic aesthetics
    vec3 digitalColor = mix(vec3(0.1, 0.3, 0.5), vec3(0.9, 0.7, 0.2), organic);
    vec3 glitchColor = mix(digitalColor, vec3(0.0), bands);
    vec3 organicColor = mix(glitchColor, vec3(0.2, 0.6, 0.8), decay * burst);
    
    // Darken around the edges to emphasize the central synthesis of styles
    float vignette = smoothstep(1.2, 0.0, radius);
    vec3 finalColor = organicColor * vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}