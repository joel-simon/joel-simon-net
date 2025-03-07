precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for(int i = 0; i < 5; i++){
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 rotate(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

vec2 sportsGlitch(vec2 pos, float seed) {
    // Inspired by abrupt fast-paced change in sports replays with digital artifact distortion.
    float glitchStrength = 0.02 * sin(time * 8.0 + pos.y * 50.0);
    pos.x += glitchStrength * (random(pos + seed) - 0.5);
    pos.y += glitchStrength * (random(pos - seed) - 0.5);
    return pos;
}

void main(){
    // Domain 1: Organic fluidity.
    vec2 centered = uv - 0.5;
    
    // Domain 2: Sports dynamics - rapid movements and metric overlays.
    // Map a running clock and scoreboard-like flicker.
    float clock = mod(time, 6.2831);
    float pulse = smoothstep(0.0, 0.1, abs(sin(clock * 3.0) * 0.5 + 0.5));
    
    // Create swirling organic pattern.
    float swirlAngle = fbm(centered * 3.0 + time) * 6.2831;
    vec2 swirled = rotate(centered, swirlAngle);
    
    // Introduce sports glitch effect for dynamic disruption.
    vec2 dynamicPos = sportsGlitch(swirled, time);
    
    // Compute a field intensity with soft organic gradients.
    float field = fbm(dynamicPos * 4.0 - time * 0.5);
    
    // Synthetic scoreboard effect: subtle gridlines and numeric-like flickers.
    vec2 gridUV = fract(dynamicPos * 10.0);
    float gridLine = smoothstep(0.0, 0.04, gridUV.x) + smoothstep(0.96, 1.0, gridUV.x);
    gridLine += smoothstep(0.0, 0.04, gridUV.y) + smoothstep(0.96, 1.0, gridUV.y);
    
    // Organic color blending with sports digital flair.
    vec3 organic = vec3(0.3 + 0.7 * field, 0.2 + 0.8 * sin(time + field * 3.1415), 0.4 + 0.6 * cos(time + field));
    vec3 digital = vec3(0.1 * gridLine, 0.15 * gridLine, 0.2 * gridLine) + vec3(0.05 * pulse);
    
    // Synthesize the two domains: natural organic flow meets abrupt sports glitch metrics.
    vec3 color = mix(organic, digital, 0.5 + 0.5 * sin(time + length(centered)*10.0));
    
    // Final blending of an occasional digital burst.
    float burst = step(0.98, random(dynamicPos*time)) * 0.3;
    color += burst;
    
    gl_FragColor = vec4(color, 1.0);
}