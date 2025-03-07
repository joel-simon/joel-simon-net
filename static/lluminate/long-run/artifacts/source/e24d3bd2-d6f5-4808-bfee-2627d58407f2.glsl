precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

float glitch(vec2 p, float t) {
    float g = noise(p * 10.0 + t);
    return smoothstep(0.3, 0.31, abs(fract(p.y * 20.0 + g * 5.0) - 0.5));
}

float vortex(vec2 p, float t) {
    p = p * 2.0 - 1.0;
    float angle = atan(p.y, p.x);
    float radius = length(p);
    float twist = sin(radius * 10.0 - t * 3.0) * 0.5;
    angle += twist;
    vec2 uvNew = vec2(cos(angle), sin(angle)) * radius;
    return exp(-10.0 * radius);
}

void main() {
    vec2 p = uv;
    
    // Background: gradient based on time to simulate shifting sky
    vec3 bgColor = mix(vec3(0.05, 0.1, 0.2), vec3(0.2, 0.3, 0.5), p.y);
    bgColor += 0.1 * sin(time + p.xyx * 10.0);
    
    // Draw an abstract vortex "error" shape: its fading edges embrace imperfections.
    float v = vortex(p, time);
    vec3 vortexColor = mix(vec3(0.8, 0.3, 0.2), vec3(0.9, 0.6, 0.2), v);
    
    // Inject glitch artifacts guided by a cryptic directive: "Honor thy error as a hidden intention."
    float g = glitch(p, time);
    vortexColor = mix(vortexColor, vec3(0.2, 0.8, 0.9), g);
    
    // Composite the vortex shape onto the background
    float shapeBlend = smoothstep(0.1, 0.0, abs(uv.y - 0.5));
    vec3 finalColor = mix(bgColor, vortexColor, shapeBlend + v);
    
    gl_FragColor = vec4(finalColor, 1.0);
}