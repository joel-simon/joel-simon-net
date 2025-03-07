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
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

vec2 rotate(vec2 p, float a) {
    float s = sin(a);
    float c = cos(a);
    return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

vec3 cyberFlora(vec2 p) {
    // Domain: Organic vines meeting digital circuits
    float n = fbm(p * 3.0 - time * 0.5);
    float vine = smoothstep(0.4, 0.35, abs(n - length(p)));
    vec3 baseColor = mix(vec3(0.1, 0.2, 0.05), vec3(0.0, 0.6, 0.2), n);
    
    // Add digital circuit glitch overlay 
    vec2 grid = fract(p * 10.0 + time);
    float circuit = smoothstep(0.48, 0.5, abs(grid.x - 0.5)) *
                    smoothstep(0.48, 0.5, abs(grid.y - 0.5));
    vec3 circuitColor = mix(vec3(0.0, 0.8, 0.7), vec3(0.9, 0.2, 0.5), circuit);
    
    return mix(baseColor, circuitColor, 0.5 * circuit) * vine;
}

vec3 cosmicRoots(vec2 p) {
    // Domain: Cosmic nebula meets organic roots
    float angle = atan(p.y, p.x) + time * 0.3;
    float radius = length(p);
    float nebula = fbm(p * 4.0 + vec2(sin(time), cos(time)));
    float root = smoothstep(0.5, 0.45, abs(nebula - radius));
    vec3 nebulaColor = mix(vec3(0.05, 0.0, 0.2), vec3(0.3, 0.0, 0.5), nebula);
    nebulaColor *= 1.0 - smoothstep(0.0, 1.0, radius);
    return nebulaColor * root;
}

void main(){
    // Center UV and scale to a reasonable domain
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Introduce a rotation driven by fbm noise for dynamic effect
    float rotation = fbm(pos * 2.0 + time) * 3.1415;
    vec2 rotatedPos = rotate(pos, rotation);
    
    // Synthesize two creative domains: cyberFlora and cosmicRoots
    vec3 flora = cyberFlora(rotatedPos);
    vec3 roots = cosmicRoots(rotatedPos);
    
    // Blend based on radial distance; digital circuits emerge in the center, cosmic in the outskirts
    float blendFactor = smoothstep(0.0, 1.0, length(pos));
    vec3 finalColor = mix(flora, roots, blendFactor);
    
    gl_FragColor = vec4(finalColor, 1.0);
}