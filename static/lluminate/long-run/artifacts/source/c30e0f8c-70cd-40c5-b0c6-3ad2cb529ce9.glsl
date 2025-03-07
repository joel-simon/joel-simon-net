precision mediump float;
varying vec2 uv;
uniform float time;

//
// Pseudo-random generator
//
float random (vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

//
// Noise function (value noise)
//
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

//
// Fractal Brownian Motion
//
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

//
// Swirling vortex function: combines polar coordinates and noise
//
vec2 swirl(vec2 coord, float strength) {
    float r = length(coord);
    float angle = atan(coord.y, coord.x);
    angle += strength / (r + 0.2);
    return vec2(r * cos(angle), r * sin(angle));
}

//
// Digital glitch effect: creates abrupt color transitions
//
vec3 digitalGlitch(vec2 pos) {
    float glitch = step(0.95, random(pos + time));
    return mix(vec3(0.0), vec3(0.8,0.9,1.0), glitch);
}

//
// Vortex field: a spiraling, pulsating effect that is modified by fbm noise
//
vec3 vortexField(vec2 pos) {
    // Scale and center coordinates
    vec2 centered = (uv - 0.5)*2.0;
    // Apply swirling transformation
    vec2 swirled = swirl(centered, time * 0.8);
    
    // Radial gradient
    float brightness = 1.0 - length(swirled);
    
    // Add fractal details
    float detail = fbm(swirled * 3.0 + time);
    
    // Combine details with brightness, enhancing the spiral arms
    float field = smoothstep(0.3, 0.0, length(swirled - detail*0.3));
    
    // Dynamic color shifting over time and position
    vec3 color = mix(vec3(0.1,0.2,0.4), vec3(0.9,0.4,0.6), field);
    color += 0.3 * vec3(sin(time + pos.x * 12.0), cos(time + pos.y * 12.0), sin(time * 1.7));
    
    return color * brightness;
}

void main() {
    // Base field with vortex effect
    vec3 baseField = vortexField(uv);
    
    // Introduce a digital glitch overlay
    vec3 glitchOverlay = digitalGlitch(uv * 10.0);
    
    // Create a subtle grid pattern with noise modulation
    vec2 gridUV = fract(uv * 20.0);
    float grid = smoothstep(0.0, 0.05, gridUV.x) + smoothstep(1.0, 0.95, gridUV.x)
               + smoothstep(0.0, 0.05, gridUV.y) + smoothstep(1.0, 0.95, gridUV.y);
    vec3 gridColor = vec3(0.2, 0.15, 0.3) * grid;
    
    // Blend all effects together: swirling vortex, digital glitch, and grid texture
    vec3 finalColor = mix(baseField, glitchOverlay, 0.2);
    finalColor = mix(finalColor, gridColor, 0.15);
    
    gl_FragColor = vec4(finalColor, 1.0);
}