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
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for(int i = 0; i < 6; i++){
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 polarTransform(vec2 pos, float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
}

vec2 glitch(vec2 pos, float seed) {
    // Create a mild glitch offset based on a sine modulation and noise disturbance
    float offset = sin(pos.y * 50.0 + seed) * 0.005 + noise(pos * 20.0 + seed) * 0.01;
    pos.x += offset;
    return pos;
}

void main(){
    // Anchor: organic digital interplay.
    // Step 1: Convert uv to centered coordinates.
    vec2 centeredUV = uv - 0.5;
    
    // Step 2: Medium association: introduce polar distortion based on fbm
    float angle = fbm(centeredUV * 3.0 + time)*6.2831;
    vec2 polarUV = polarTransform(centeredUV, angle * 0.2);
    
    // Step 3: Further glitching effect.
    vec2 distortedUV = glitch(polarUV + 0.5, time);
    
    // Step 4: Use distance from center to create a vortex effect.
    float radius = length(centeredUV);
    float vortex = smoothstep(0.3, 0.0, radius + 0.3 * sin(time + radius * 12.0));
    
    // Step 5: Organic lighting: blend two color dynamics using fbm.
    float n = fbm(distortedUV * 4.0 + time);
    vec3 organicColor = vec3(0.5 + 0.5*sin(time + n*6.2831), 0.5 + 0.3*cos(time + n*6.2831), 0.4 + 0.4*sin(time+n));
    
    // Step 6: Digital grid overlay
    vec2 grid = fract(distortedUV * 15.0);
    float lineX = smoothstep(0.0, 0.03, grid.x) + smoothstep(1.0, 0.97, grid.x);
    float lineY = smoothstep(0.0, 0.03, grid.y) + smoothstep(1.0, 0.97, grid.y);
    vec3 gridColor = vec3(0.1, 0.2, 0.3) * (lineX + lineY);
    
    // Step 7: Combine digital and organic based on vortex factor.
    vec3 finalColor = mix(gridColor, organicColor, vortex);
    
    // Step 8: Add subtle random glitch bursts.
    float burst = step(0.98, random(distortedUV * time)) * 0.2;
    finalColor += burst;
    
    gl_FragColor = vec4(finalColor, 1.0);
}