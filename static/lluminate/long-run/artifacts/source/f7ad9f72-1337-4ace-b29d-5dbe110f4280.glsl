precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

vec2 polar(vec2 p) {
    float r = length(p);
    float a = atan(p.y, p.x);
    return vec2(r, a);
}

vec2 polarToCart(vec2 pa) {
    return vec2(pa.x*cos(pa.y), pa.x*sin(pa.y));
}

vec2 modSwirl(vec2 pos, float factor) {
    pos -= 0.5;
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    a += factor / (r + 0.2);
    pos = vec2(r * cos(a), r * sin(a));
    pos += 0.5;
    return pos;
}

void main(void) {
    vec2 pos = uv;
    
    // Domain synthesis: Fossils (organic decay patterns) meet musical pulses (rhythmic sound waves)
    // Create a base fossil texture using radial noise and soft decay edges
    vec2 centered = pos - 0.5;
    float radius = length(centered);
    float decay = smoothstep(0.45, 0.5, radius);
    
    float fossilNoise = noise(pos * 12.0 + time*0.3);
    float fossilTexture = smoothstep(0.3, 0.7, fossilNoise);
    
    // Introduce rhythmic pulses inspired by musical beats, modulated by time and angle.
    vec2 pa = polar(centered);
    float beat = sin(8.0 * pa.y + time * 4.0);
    beat = smoothstep(0.2, 0.25, abs(beat));
    
    // Combine fossil texture and rhythmic pulses.
    float pattern = mix(fossilTexture, beat, 0.5);
    
    // Add an abstract swirl to simulate a fusion of organic decay and digital remix
    vec2 swirled = modSwirl(pos, 2.5 * sin(time*1.2));
    float swirlNoise = noise(swirled * 20.0 - time);
    pattern = mix(pattern, swirlNoise, 0.3);
    
    // Color palette: earthy fossil tones with vibrant neon highlights representing musical energy.
    vec3 fossilColor = mix(vec3(0.2, 0.15, 0.1), vec3(0.4, 0.35, 0.3), fossilTexture);
    vec3 beatColor = mix(vec3(0.1, 0.05, 0.2), vec3(0.7, 0.2, 0.9), beat);
    vec3 finalColor = mix(fossilColor, beatColor, 0.5);
    
    // Blend in additional color based on the swirled noise to enhance digital glitch feel.
    finalColor = mix(finalColor, vec3(0.05, 0.8, 0.6), swirlNoise*0.2);
    
    // Darken around the edges for an ancient, fossilized frame effect.
    finalColor *= (1.0 - decay);
    
    gl_FragColor = vec4(finalColor, 1.0);
}