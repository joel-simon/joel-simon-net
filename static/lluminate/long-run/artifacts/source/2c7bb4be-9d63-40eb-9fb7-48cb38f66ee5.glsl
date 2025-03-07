precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
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

vec3 organicTree(vec2 pos) {
    vec2 t_pos = pos;
    t_pos.y += 0.3 * sin(time + t_pos.x * 10.0);
    float branches = fbm(t_pos * 5.0 + time * 0.5);
    float branchShape = smoothstep(0.45, 0.5, abs(fract(pos.x * 10.0 + branches) - 0.5));
    vec3 branchColor = mix(vec3(0.2, 0.1, 0.0), vec3(0.0, 0.5, 0.1), pos.y + 0.5);
    return branchColor * branchShape;
}

void main() {
    vec2 pos = (uv - 0.5) * 2.0;
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Swirling cosmic field with dynamic noise and color blending.
    vec2 warped = pos;
    float s = sin(time * 0.5), c = cos(time * 0.5);
    warped = vec2(c * warped.x - s * warped.y, s * warped.x + c * warped.y);
    float swirl = fbm(warped * 2.0 + time);
    float vortex = smoothstep(0.5, 0.0, abs(sin(6.2831 * (radius - swirl))));
    
    vec3 cosmicField = vec3(
        0.1 + 0.9 * fbm(uv * 3.0 + time),
        0.2 + 0.8 * vortex,
        0.5 + 0.5 * sin(time + radius * 3.14)
    );
    
    // Glitch-art inspired swirling waves.
    float wave1 = sin(10.0 * radius - 3.0 * time + 5.0 * angle);
    float wave2 = sin(20.0 * radius - 2.0 * time + 3.0 * angle);
    float waveCombo = (wave1 + wave2) / 2.0;
    waveCombo += (random(uv * time) - 0.5) * 0.2;
    vec3 waveColor = mix(
        vec3(0.5 + 0.5 * cos(time + radius * 10.0 + vec3(0.0, 2.0, 4.0))),
        vec3(0.5 + 0.5 * sin(time - radius * 10.0 + vec3(4.0, 2.0, 0.0))),
        smoothstep(-1.0, 1.0, radius)
    );
    waveColor += sin(10.0 * radius - time + 3.0 * angle) * 0.3;
    
    // Organic tree branch overlay representing natural growth.
    vec3 treeBranches = organicTree(uv * 2.0 - 1.0);
    
    // Combine cosmic field, glitch waves, and tree branches.
    vec3 mixField = mix(waveColor, cosmicField, vortex);
    vec3 finalColor = mix(treeBranches, mixField, 0.5);
    
    // Apply vignette for depth.
    float vignette = smoothstep(0.8, 0.2, radius);
    finalColor *= vignette;
    
    // Occasional bursts of organic light.
    float burst = step(0.98, random(uv * time * 0.7)) * 0.2;
    finalColor += burst;
    
    gl_FragColor = vec4(finalColor, 1.0);
}