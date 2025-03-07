precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 103.27);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b)* u.x * u.y;
}

float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 6; i++) {
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

vec2 digitalDisrupt(vec2 p) {
    float offset = fbm(vec2(p.y * 10.0, time * 0.5));
    return p + vec2(offset * 0.03, 0.0);
}

vec2 medievalWarp(vec2 p, float strength) {
    p = (p - 0.5) * 2.0;
    float r = length(p);
    float theta = atan(p.y, p.x);
    theta += sin(r * 5.0 - time * 2.0) * strength;
    vec2 warped = vec2(cos(theta), sin(theta)) * r;
    return (warped * 0.5 + 0.5);
}

float tapestryPattern(vec2 p) {
    p *= 20.0;
    vec2 ip = floor(p);
    vec2 fp = fract(p);
    float line = smoothstep(0.48, 0.5, fp.x) + smoothstep(0.48, 0.5, fp.y);
    float pattern = step(0.5, mod(ip.x + ip.y, 2.0));
    return pattern * (1.0 - line);
}

void main(void) {
    vec2 pos = uv;
    
    // Step 1: Digital glitch inspired disruption from a futuristic clockwork domain
    pos = digitalDisrupt(pos);
    
    // Step 2: Medieval warp simulating the aging of a woven tapestry
    vec2 warpPos = medievalWarp(pos, 0.3 + 0.2 * sin(time * 0.8));
    
    // Step 3: Synthesize with a combination of digital structure and ancient patterns
    float digitalLayer = fbm(pos * 6.0 + time * 0.3);
    float tapestryLayer = tapestryPattern(warpPos);
    
    // Blend layers using a non-linear mix to simulate synthesis of realms
    float blend = mix(digitalLayer, tapestryLayer, 0.55);
    
    // Color synthesis: using cold digital cyan contrasted with warm deep sepia
    vec3 digitalColor = vec3(0.0, 0.8, 0.9) * digitalLayer;
    vec3 tapestryColor = vec3(0.6, 0.3, 0.1) * tapestryLayer;
    vec3 base = mix(digitalColor, tapestryColor, blend);
    
    // Add subtle rhythmic pulsing as a nod to temporal evolution
    base += 0.1 * vec3(sin(time*3.0), sin(time*2.5), sin(time*3.5));
    
    gl_FragColor = vec4(base, 1.0);
}