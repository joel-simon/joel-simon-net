precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(63.31, 127.21))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    vec2 u = f * f * (3.0 - 2.0 * f);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
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

vec2 polarTransform(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

void main(){
    // Center UV coordinates
    vec2 pos = uv - 0.5;
    
    // Apply FBM-based swirl for an organic, chaotic twist
    float swirl = fbm(pos * 5.0 + time);
    float angle = swirl * 6.2831;
    vec2 rotatedPos = polarTransform(pos, angle);
    
    // Introduce hidden intentional error: misalign color channels
    vec2 redUV = rotatedPos + vec2(0.01 * sin(time * 3.0), 0.01 * cos(time * 2.0));
    vec2 greenUV = rotatedPos + vec2(-0.01 * cos(time * 3.0), 0.01 * sin(time * 2.0));
    vec2 blueUV = rotatedPos + vec2(0.01 * cos(time * 3.0), -0.01 * sin(time * 2.0));
    
    float r = fbm(redUV * 3.0 + time);
    float g = fbm(greenUV * 3.0 + time * 0.8);
    float b = fbm(blueUV * 3.0 + time * 1.2);
    
    // Honor thy error as a hidden intention:
    // Occasionally swap red and green to simulate an unexpected glitch.
    if(random(uv * 10.0 + time) > 0.98) {
        float temp = r;
        r = g;
        g = temp;
    }
    
    vec3 color = vec3(r, g, b);
    
    // Apply smooth color gradient for a soft tone mapping effect
    color = smoothstep(0.3, 0.7, color);
    
    gl_FragColor = vec4(color, 1.0);
}