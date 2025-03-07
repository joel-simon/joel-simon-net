precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(13.0, 37.0))) * 43758.5453);
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
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Directive: "Honor thy error as a hidden intention."
// Interpret: Let intentional "errors" be introduced as disjointed, glitch offsets, not fully erased but artistically embraced.
vec2 errorGlitch(vec2 pos) {
    float glitch = step(0.95, fract(sin(dot(pos.xy, vec2(12.9898,78.233))) * 43758.5453 + time));
    float offset = glitch * (noise(pos * 20.0 + time) - 0.5) * 0.15;
    return pos + vec2(offset, 0.0);
}

void main(void) {
    // Use uv centered in [-1,1] space.
    vec2 pos = (uv - 0.5) * 2.0;
    pos = errorGlitch(pos);
    
    // Create swirling vortex using polar coordinates.
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Vortex pulse with intentional disruptive noise.
    float vortex = sin(angle * 6.0 + time * 2.0 + fbm(pos * 3.0)) * 0.3;
    float mask = smoothstep(0.7 + vortex, 0.68 + vortex, radius);
    
    // Create an organic grid that appears like fractal error patterns.
    float grid = sin((pos.x + time) * 10.0) * sin((pos.y - time) * 10.0);
    grid = smoothstep(0.2, 0.25, abs(grid));
    
    // Blend two visionary color schemes:
    // Deep cosmic blues with radiant glitch greens.
    vec3 cosmic = vec3(0.1, 0.2, 0.5) + 0.3 * vec3(sin(time), cos(time), sin(time * 0.5));
    vec3 glitch = vec3(0.0, 0.8, 0.5) * abs(sin(time * 3.0 + angle));
    
    // Using fbm to modulate a surreal organic texture.
    float organic = fbm(pos * 4.0 + time);
    vec3 colorMix = mix(cosmic, glitch, organic);
    
    // Introduce disruptive "error" bands from our glitch grid.
    vec3 finalColor = mix(colorMix, vec3(1.0, 1.0, 1.0), grid * 0.5);
    
    finalColor *= mask;
    
    gl_FragColor = vec4(finalColor, 1.0);
}