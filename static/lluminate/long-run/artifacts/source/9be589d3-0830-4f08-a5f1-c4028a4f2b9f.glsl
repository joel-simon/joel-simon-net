precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x),
               u.y);
}

float fbm(vec2 p) {
    float sum = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 6; i++){
        sum += noise(p) * amp;
        p *= 2.0;
        amp *= 0.5;
    }
    return sum;
}

vec2 reversedGlitch(vec2 p, float t) {
    float offset = step(0.97, fract(sin(dot(p, vec2(43.23, 91.73)) + t * 5.0))) * 0.08;
    return p - vec2(0.0, offset);
}

void main(){
    // Transform uv coordinates with reversed polarity for digital decay effect.
    vec2 st = (uv - 0.5) * 2.0;
    
    // Substitute the typical organic flow with a harsh digital grid.
    vec2 grid = floor((st + 1.0) * 8.0) / 8.0;
    
    // Apply a modified fractal noise to simulate digital artifact fragmentation.
    float artifact = fbm(grid * 4.5 - time * 0.4);
    
    // Use reversed glitch distortion to simulate digital decay in vertical shifts.
    vec2 glitchUV = reversedGlitch(st, time);
    float disintegrate = smoothstep(0.4, 0.42, length(glitchUV));
    
    // Create pulsating banding effect using high frequency sine waves.
    float band = step(0.85, abs(sin((st.y - time * 0.3) * 25.0)));
    
    // Blend two contrasting digital palettes.
    vec3 digitalBase = vec3(0.05, 0.15, 0.25);
    vec3 digitalHighlight = vec3(0.95, 0.6, 0.15);
    vec3 mixedColor = mix(digitalBase, digitalHighlight, artifact);
    
    // Integrate digital decay with band reset and disintegration mask.
    vec3 color = mix(mixedColor, vec3(0.0), band);
    color = mix(color, digitalHighlight, disintegrate);
    
    // Apply an outer vignette effect emphasizing decay towards edges.
    float vignette = smoothstep(1.1, 0.3, length(st));
    vec3 finalColor = color * vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}