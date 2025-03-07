precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0,0.0));
    float c = hash(i + vec2(0.0,1.0));
    float d = hash(i + vec2(1.0,1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for(int i = 0; i < 5; i++){
        total += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

// Directive: "Honor thy error as a hidden intention"
// We introduce an intentional error band that creates discontinuities.
float errorPattern(vec2 p) {
    float err = sin(p.y * 30.0 + time * 5.0);
    return smoothstep(0.0, 0.1, abs(fract(err) - 0.5));
}

// A different glitch: distort polar coordinates sporadically.
vec2 polarGlitch(vec2 pos) {
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    float glitch = 0.03 * sin(10.0 * a + time * 7.0) * step(0.3, r);
    a += glitch;
    return vec2(r * cos(a), r * sin(a));
}

void main(void) {
    // Map uv to centered coordinates
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Introduce a subtle glitch offset based on noise.
    vec2 offset = vec2(noise(vec2(pos.y, time*0.5)) * 0.1, 0.0);
    pos += offset;
    
    // Apply polar glitch transformation
    pos = polarGlitch(pos);
    
    // Compute a swirling fractal background using fbm.
    float swirl = fbm(pos * 2.5 + time * 0.3);
    
    // Integrate the intentional "error" imprint.
    float errorBand = errorPattern(pos * 5.0);
    
    // Combine the swirl and error bands for unexpected patterns.
    float structure = smoothstep(0.4, 0.6, swirl) + errorBand * 0.5;
    
    // Generate contrasting color dynamics.
    vec3 base = mix(vec3(0.2, 0.6, 0.8), vec3(0.9, 0.3, 0.5), swirl);
    vec3 glitchColor = vec3(0.95, 0.95, 0.7);
    
    // Apply the structure as a mask.
    vec3 color = mix(base, glitchColor, structure);
    
    // Final modulation simulating digital decay blended with organic smoothness.
    color *= smoothstep(0.0, 1.0, 1.0 - length(pos));
    
    gl_FragColor = vec4(color, 1.0);
}