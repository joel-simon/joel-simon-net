precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453123);
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

float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for(int i = 0; i < 5; i++){
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

vec2 swirl(vec2 pos, float strength) {
    float angle = strength * length(pos);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
}

void main(void) {
    // Transform UV coordinates to center at (0,0) with aspect correction.
    vec2 pos = (uv - 0.5) * 2.0;

    // Creative Strategy:
    // Anchor: Organic pulse (heartbeat)
    // Medium association: Swirling vortex representing life force flow.
    // Develop association by mixing swirling motion with fractal noise.
    
    // Apply a dynamic swirl effect influenced by time.
    pos = swirl(pos, 3.0 * sin(time * 0.5));
    
    // Create a pulsing effect modulated by distance.
    float radius = length(pos);
    float pulse = smoothstep(0.4, 0.42, abs(sin(time * 3.0 - radius * 8.0)));
    
    // Generate fractal noise for organic texture.
    float organic = fbm(pos * 3.0 + time);
    
    // Create an evolving vortex pattern.
    float vortex = smoothstep(0.6, 0.58, radius + organic * 0.2);
    
    // Blend colors: cool cyan for digital decay and warm magenta for organic vitality.
    vec3 vortexColor = mix(vec3(0.0, 0.8, 0.9), vec3(0.9, 0.2, 0.5), organic);
    
    // Combine the pulse intensity with vortex color.
    vec3 finalColor = mix(vortexColor, vec3(1.0), pulse * 0.5);
    
    // Darken outer edges based on vortex pattern.
    finalColor *= vortex;
    
    gl_FragColor = vec4(finalColor, 1.0);
}