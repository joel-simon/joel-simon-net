precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

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

vec2 glitch(vec2 p, float t) {
    float shift = step(0.95, fract(sin(dot(p.xy, vec2(12.345, 67.890)) + t*7.0)))*0.1;
    return p + vec2(shift, 0.0);
}

void main(){
    // Creative reversal: instead of fluid organic growth, we have broken, static digital decay.
    // Transform uv so center is at (0,0) and aspect is maintained.
    vec2 st = uv * 2.0 - 1.0;
    
    // Grid-based digital artifact: use floor to create blockiness.
    vec2 grid = floor((st + 1.0) * 5.0) / 5.0;
    
    // FBM produces rough noise texture that now becomes a digital crack pattern.
    float cracks = fbm(grid * 3.0 + time*0.3);
    
    // Reverse assumption: instead of natural evolution, we force breakdown.
    // Simulate fragmentation using modulated glitch distortion.
    vec2 distorted = glitch(st, time);
    float fragment = smoothstep(0.3, 0.35, length(distorted));
    
    // Create a sharp digital band effect.
    float bands = step(0.8, abs(sin((st.y + time*0.5)*20.0)));
    
    // Combine elements: glitches, digital cracks and block noise.
    vec3 colorA = vec3(0.1, 0.3, 0.5); // digital base
    vec3 colorB = vec3(0.9, 0.7, 0.2); // decay highlight
    vec3 baseColor = mix(colorA, colorB, cracks);
    
    // Introduce chaos with bands and fragment mask.
    vec3 glitchColor = mix(baseColor, vec3(0.0), bands);
    glitchColor = mix(glitchColor, colorB, fragment);
    
    // Apply an outer vignette reminiscent of aging digital screens.
    float v = smoothstep(1.2, 0.0, length(st));
    vec3 finalColor = glitchColor * v;
    
    gl_FragColor = vec4(finalColor, 1.0);
}