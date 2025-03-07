precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(63.31, 37.17))) * 43758.5453);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float flicker(vec2 p, float speed) {
    return smoothstep(0.2, 0.8, abs(sin(p.x * 10.0 + time * speed)));
}

void main(void) {
    // Remap uv from [0, 1] to [-1, 1] and perturb with noise
    vec2 pos = uv * 2.0 - 1.0;
    pos += vec2(noise(uv * 5.0 + time * 0.3), noise(uv * 7.0 - time * 0.2)) * 0.2;

    // Create radial stripes morphing in time
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    float stripe = abs(sin(12.0 * angle + time * 3.0));
    stripe = smoothstep(0.4, 0.42, stripe);

    // Apply a glitch reversal effect using noise along y
    float glitch = noise(vec2(uv.y * 15.0 - time, uv.x * 15.0));
    glitch = step(0.8, glitch);

    // Organic pulsation using flicker function to add light bursts  
    float pulse = flicker(pos, 4.0) * smoothstep(0.6, 0.4, radius);

    // Substitute color palette: digital cyan and organic magenta
    vec3 baseColor = mix(vec3(0.9, 0.2, 0.7), vec3(0.1, 0.9, 0.9), uv.y);
    
    // Combine digital glitch effect with organic radial stripe pattern
    vec3 finalColor = baseColor * (0.5 + 0.5 * stripe);
    finalColor += pulse * vec3(1.0, 0.8, 0.3);
    finalColor = mix(finalColor, vec3(0.0, 0.0, 0.0), glitch * 0.7);
    
    gl_FragColor = vec4(finalColor, 1.0);
}