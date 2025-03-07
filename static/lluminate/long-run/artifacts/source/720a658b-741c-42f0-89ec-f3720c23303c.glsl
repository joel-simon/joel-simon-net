precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0,0.0)), hash(i + vec2(1.0,0.0)), u.x),
               mix(hash(i + vec2(0.0,1.0)), hash(i + vec2(1.0,1.0)), u.x), u.y);
}

float fbm(vec2 p) {
    float total = 0.0, amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

vec2 rotate(vec2 p, float a) {
    float s = sin(a), c = cos(a);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

vec2 glitchOffset(vec2 p, float t) {
    // Directive: "Use an old idea" - Embrace outdated analog glitches.
    float offsetX = sin(p.y * 10.0 + t * 2.0) * 0.03;
    float offsetY = cos(p.x * 10.0 - t * 2.0) * 0.03;
    return p + vec2(offsetX, offsetY);
}

void main(void) {
    // Interpret the directive by mixing classic analog distortions with modern generative noise.
    vec2 p = uv - 0.5;
    p *= 1.5;
    
    // Introduce a slow swirling rotation
    float swirl = fbm(p * 2.0 + time * 0.3);
    p = rotate(p, swirl * 3.1415);
    
    // Apply glitch offsets reminiscent of vintage analog errors.
    p = glitchOffset(p, time);
    
    // Generate two noise layers for organic structure and digital decay.
    float base = fbm(p * 3.0 + time);
    float detail = fbm(p * 15.0 - time * 0.5);
    
    // Mix color layers: warm old film with futuristic glitch neon.
    vec3 film = mix(vec3(0.4, 0.3, 0.2), vec3(0.6, 0.5, 0.4), base);
    vec3 neon = vec3(0.1, 0.8, 0.6) * abs(sin(time + detail * 6.2831));
    
    // Create an edge grid hinting at digital decay.
    vec2 grid = fract(uv * 25.0 - time);
    float lines = smoothstep(0.45, 0.55, grid.x) + smoothstep(0.45, 0.55, grid.y);
    
    // Blend the analog film and futuristic neon with the aged digital lines.
    vec3 color = mix(film, neon, 0.5 * lines);
    
    // Add a soft vignette, reminiscent of old cameras.
    float vignette = smoothstep(0.8, 0.3, length(uv - 0.5));
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}