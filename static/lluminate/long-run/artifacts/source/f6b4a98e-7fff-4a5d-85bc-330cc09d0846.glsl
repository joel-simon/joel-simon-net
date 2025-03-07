precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(17.0, 43.0))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
	vec2 u = f * f * (3.0 - 2.0 * f);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++){
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 swirl(vec2 pos, float strength) {
    float angle = strength * length(pos);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
}

vec3 bubbleField(vec2 pos) {
    float d = length(pos);
    float n = fbm(pos * 2.0 - time * 0.5);
    float bubbles = smoothstep(0.3, 0.31, abs(n - d));
    vec3 col = mix(vec3(0.2, 0.05, 0.4), vec3(0.7, 0.2, 0.9), n);
    return col * bubbles;
}

vec3 digitalSparks(vec2 pos) {
    // Create spark bursts along a radial gradient
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    float sparks = smoothstep(0.01, 0.005, abs(sin(10.0*angle + time * 3.0) * 0.1 - radius));
    vec3 col = vec3(0.9, 0.8, 0.5) * sparks;
    return col;
}

void main(){
    // Center and scale uv
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Anchor: swirling water bubble pattern
    // Medium association: ephemeral digital sparks
    vec2 swirledPos = swirl(pos, 2.5);
    vec3 bubbles = bubbleField(swirledPos);
    
    // Apply a secondary digital layer that emerges from swirl
    vec3 sparks = digitalSparks(pos);
    
    // Create a balanced composite via radial mixing; inner part brighter with sparks
    float mixFactor = smoothstep(0.0, 1.0, length(pos));
    vec3 colorMix = mix(bubbles, sparks, mixFactor);
    
    gl_FragColor = vec4(colorMix, 1.0);
}