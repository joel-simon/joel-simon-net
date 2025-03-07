precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f*f*(3.0-2.0*f);
    return mix(mix(hash(i + vec2(0.0,0.0)), hash(i + vec2(1.0,0.0)), u.x),
               mix(hash(i + vec2(0.0,1.0)), hash(i + vec2(1.0,1.0)), u.x), u.y);
}

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++){
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 vortex(vec2 p, float strength) {
    float angle = strength * fbm(p * 4.0 + time*0.5);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

vec3 nebulaColors(float t) {
    return vec3(0.5 + 0.5*sin(t + vec3(0.0,2.0,4.0)));
}

vec3 organicNebula(vec2 p) {
    // Create organic bubbles that merge and twist like cosmic coral
    float r = length(p - 0.5);
    float bubble = smoothstep(0.32, 0.3, r + 0.15 * sin(time + fbm(p * 8.0)*6.2831));
    float pattern = fbm(p * 12.0 + time);
    vec3 color = mix(vec3(0.1, 0.3, 0.2), nebulaColors(pattern*6.2831), bubble);
    return color;
}

vec3 digitalFract(vec2 p) {
    // Create a digital grid overlay that pulses and glitches
    vec2 grid = fract(p * 30.0 - vec2(time*0.3));
    float line = smoothstep(0.02, 0.0, abs(grid.x - 0.5)) + smoothstep(0.02, 0.0, abs(grid.y - 0.5));
    float glitch = step(0.92, noise(p * 15.0 + time*2.0));
    vec3 col = mix(vec3(0.0, 0.0, 0.15), vec3(0.4, 0.6, 0.8), line + glitch*0.5);
    return col;
}

void main(){
    vec2 pos = uv;
    
    // Distort the coordinate field with a vortex effect inspired by swirling galaxies
    vec2 distorted = vortex(pos, 6.0);
    
    // Create organic nebula-like shapes that mimic coral growth in space
    vec3 organic = organicNebula(distorted);
    
    // Digital fractal overlay: a grid with glitchy artifacts intersecting the organic field
    vec3 digital = digitalFract(pos);
    
    // Merge the two domains by blending them with a time-modulated mix factor
    float blend = smoothstep(0.3, 0.7, noise(pos * 4.0 + time));
    vec3 finalColor = mix(organic, digital, blend);
    
    // Apply subtle vignetting
    float vignette = smoothstep(0.8, 0.3, length(pos - 0.5));
    gl_FragColor = vec4(finalColor * vignette, 1.0);
}