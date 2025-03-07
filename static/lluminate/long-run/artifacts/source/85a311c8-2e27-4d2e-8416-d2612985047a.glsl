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
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 errorGlitch(vec2 pos, float seed) {
    // Directive: "Honor thy error as a hidden intention"
    // Apply intentional misalignment by perturbing the coordinates randomly.
    float glitch = sin(pos.y * 40.0 + seed) * 0.01 + noise(pos * 30.0 + seed) * 0.02;
    return pos + vec2(glitch, -glitch);
}

vec2 polarCoord(vec2 pos) {
    // Convert to polar coordinates and add time-based twist.
    float r = length(pos);
    float theta = atan(pos.y, pos.x) + 0.5 * sin(time + r * 10.0);
    return vec2(r, theta);
}

vec2 fromPolar(vec2 polar) {
    // Convert polar coordinates back to cartesian.
    return vec2(polar.x * cos(polar.y), polar.x * sin(polar.y));
}

void main(){
    // Center uv coordinates
    vec2 centeredUV = uv - 0.5;

    // Step 1: Apply polar coordinate transformation with a twist.
    vec2 polar = polarCoord(centeredUV);
    
    // Step 2: Use fbm to distort the radius subtly, representing a natural error.
    float distort = fbm(vec2(polar.y * 3.0, time * 0.5));
    polar.x += (distort - 0.5) * 0.1;
    
    // Step 3: Convert back to cartesian coordinates.
    vec2 newPos = fromPolar(polar);
    
    // Step 4: Apply an intentional glitch based on directive "Honor thy error as a hidden intention".
    newPos = errorGlitch(newPos, time);
    
    // Step 5: Generate an organic color palette modulated by noise and time.
    float n = fbm(newPos * 5.0 + time);
    vec3 organic = vec3(0.5 + 0.5*sin(time + n*6.28),
                        0.5 + 0.5*sin(time + n*3.14 + 1.57),
                        0.5 + 0.5*cos(time + n*6.28));
    
    // Step 6: Create a soft vignette effect based on distance from center.
    float vignette = smoothstep(0.6, 0.0, length(centeredUV));
    
    // Step 7: Combine the effects
    vec3 color = organic * vignette;
    
    gl_FragColor = vec4(color, 1.0);
}