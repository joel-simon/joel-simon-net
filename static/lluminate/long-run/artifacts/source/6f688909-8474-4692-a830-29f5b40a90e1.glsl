precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 p) {
    float f = 0.0;
    f += noise(p) * 0.5;
    p *= 2.02;
    f += noise(p) * 0.25;
    p *= 2.03;
    f += noise(p) * 0.125;
    p *= 2.01;
    f += noise(p) * 0.0625;
    return f;
}

void main(void) {
    // Reverse assumption: Instead of typical smooth transitions and noise, create a chaotic grid of instantaneous disruptions.
    vec2 pos = uv * 2.0 - 1.0;
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    
    // Create a grid-like structure of glitch lines
    float gridX = smoothstep(0.015, 0.0, abs(fract(uv.x * 20.0 - time * 0.5) - 0.5));
    float gridY = smoothstep(0.015, 0.0, abs(fract(uv.y * 20.0 + time * 0.5) - 0.5));
    float grid = max(gridX, gridY);
    
    // Use fbm to simulate counter-intuitive organic formations that emerge from chaos
    float chaoticNoise = fbm(uv * 10.0 + time * 0.3);
    
    // Reverse conventional swirl: instead of radius-based circular distortion, apply a polar twist based on noise
    float twist = sin(a * 3.0 + chaoticNoise * 5.0 + time) * 0.4;
    vec2 twistedUV = vec2(
        uv.x + twist * cos(a),
        uv.y + twist * sin(a)
    );
    
    // Generate a background of disjoint digital fragments
    float fragment = step(0.5, fract(sin(dot(twistedUV * 10.0, vec2(12.9898,78.233))) * 43758.5453));
    
    // Compose layers: chaotic organic gradient with digital glitch fragmented overlay
    vec3 organic = vec3(0.2 + chaoticNoise * 0.8, 0.3, 0.4 + 0.6 * (1.0 - chaoticNoise));
    vec3 digital = vec3(0.8 * fragment, 0.6 * (1.0 - fragment), 0.3);
    
    // Blend the two themes by modulating with grid disruption
    vec3 colorMix = mix(organic, digital, grid);
    
    // Add a subtle pulsing effect from the center for an eerie glow
    float glow = 1.0 - smoothstep(0.2, 0.5, r + 0.1 * sin(time * 3.0));
    colorMix += glow * vec3(0.9, 0.8, 0.3);
    
    gl_FragColor = vec4(colorMix, 1.0);
}