precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

vec2 toPolar(vec2 p) {
    float r = length(p);
    float a = atan(p.y, p.x);
    return vec2(r, a);
}

vec2 toCartesian(vec2 polar) {
    return vec2(polar.x * cos(polar.y), polar.x * sin(polar.y));
}

vec2 swirl(vec2 p, float strength) {
    vec2 polar = toPolar(p);
    polar.y += strength / (polar.x + 0.5);
    return toCartesian(polar);
}

float heartShape(vec2 pos) {
    pos *= 1.3;
    float x = pos.x;
    float y = pos.y;
    return (x*x + y*y - 1.0) * (x*x + y*y - 1.0) * (x*x + y*y - 1.0) - x*x*y*y*y;
}

void main() {
    // Transform uv to centered coordinate space [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply time-varying rotation
    float angle = time * 0.5;
    float s = sin(angle);
    float c = cos(angle);
    pos = vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
    
    // Apply swirling distortion to add organic twist
    float swirlStrength = sin(time * 0.8) * 0.5;
    vec2 distortedPos = swirl(pos, swirlStrength);
    
    // Generate fractal noise pattern over the distorted coordinates
    float f = 0.0;
    float amplitude = 1.0;
    vec2 nPos = distortedPos * 2.0;
    for (int i = 0; i < 6; i++) {
        f += amplitude * noise(nPos + vec2(time * 0.3));
        nPos *= 1.7;
        amplitude *= 0.5;
    }
    
    // Create a glitchy grid overlay
    vec2 grid = fract(uv * 10.0) - 0.5;
    float gridLines = smoothstep(0.48, 0.5, abs(grid.x)) + smoothstep(0.48, 0.5, abs(grid.y));
    float glitch = step(0.98, random(uv * time)) * 0.15;
    
    // Evaluate the heart shape function
    float heartVal = heartShape(pos * 1.2);
    float heartMask = smoothstep(0.02, -0.02, heartVal);
    
    // Create a dynamic color modulation based on noise and time for the heart area
    vec3 heartColor = vec3(0.2 + 0.7 * sin(f + time),
                           0.2 + 0.7 * cos(f - time),
                           0.5 + 0.5 * sin(2.0 * f + time));
    
    // Base background color with glitch elements and waves
    vec3 bgColor = vec3(0.05, 0.02, 0.1) + 0.2 * vec3(sin(time * 0.3), cos(time * 0.4), sin(time * 0.5));
    bgColor += gridLines * 0.15 + glitch;
    
    // Mix the heart area with background based on the shape mask
    vec3 color = mix(bgColor, heartColor, heartMask);
    
    // Add additional organic color modulation using fractal noise
    vec3 dynamicOffset = vec3(0.5 * sin(time + f), 0.5 * cos(time + f*1.2), 0.5 * sin(time * 1.5 + f * 0.8));
    color += dynamicOffset * 0.1;
    
    // Apply vignette effect
    float vignette = smoothstep(1.0, 0.2, length(pos));
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}