precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(63.31, 37.19))) * 43758.5453123);
}

float errorAsIntention(vec2 st) {
    // "Honor thy error as a hidden intention"
    // Create a subtle, unexpected noise dip that simulates an error.
    float noiseVal = pseudoRandom(st);
    return smoothstep(0.4, 0.5, noiseVal) * (1.0 - step(0.48, noiseVal));
}

float swirl(vec2 st, float strength) {
    vec2 center = vec2(0.5);
    st -= center;
    float angle = strength * length(st);
    float s = sin(angle);
    float c = cos(angle);
    st = vec2(st.x * c - st.y * s, st.x * s + st.y * c);
    st += center;
    return st.x;
}

vec3 generatePattern(vec2 pos) {
    // Apply an unorthodox combination: swirling offsets with error-inspired dips
    vec2 p = pos;
    
    // Use swirl with time varying strength and incorporate error signal
    float err = errorAsIntention(p * 3.0 + time * 0.5);
    float strength = 3.1415 * (0.3 + err * 0.7);
    p.x = swirl(p, strength);
    
    // Create stripes that pulsate with time
    float stripes = sin(p.y * 40.0 + time * 5.0) * 0.5 + 0.5;
    
    // Create subtle circular blurs over the stripes to mimic liquid digital error
    float dist = length(p - vec2(0.5));
    float spot = smoothstep(0.4, 0.38, dist);
    
    // Combine for a creative outcome
    vec3 color = mix(vec3(0.1, 0.2, 0.4), vec3(0.7, 0.3, 0.2), stripes);
    color += spot * vec3(0.2, 0.4, 0.6);
    
    // Introduce a sporadic glitch factor
    float glitch = step(0.98, pseudoRandom(pos * 15.0 + time));
    color = mix(color, vec3(0.9, 0.1, 0.7), glitch * 0.5);
    
    return color;
}

void main(){
    vec2 pos = uv;
    
    // Introduce a subtle warp to break expectations
    pos += 0.02 * vec2(sin(7.0 * pos.y + time), cos(7.0 * pos.x - time));
    
    // Use a radial gradient base that hints at organic growth juxtaposed with digital distortion
    float radial = smoothstep(0.0, 0.5, length(pos - vec2(0.5)));
    vec3 base = mix(vec3(0.05, 0.05, 0.1), vec3(0.4, 0.3, 0.8), radial);
    
    vec3 pattern = generatePattern(pos);
    
    // Blend base and creative pattern in a way that "honors the error"
    float blend = smoothstep(0.3, 0.7, errorAsIntention(pos * 5.0 + time));
    vec3 finalColor = mix(base, pattern, blend);
    
    gl_FragColor = vec4(finalColor, 1.0);
}