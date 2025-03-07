precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float swirlingChaos(vec2 p) {
    // Reverse the usual assumption of a neat, coherent center by dispersing swirling vortices randomly.
    vec2 c = p - 0.5;
    float angle = atan(c.y, c.x);
    float radius = length(c);
    // Create dynamic vortices that change over time with a blend of sine and noise.
    float vortex = sin(5.0 * angle + time + noise(p * 10.0)) * cos(3.0 * radius * 10.0 - time);
    return smoothstep(0.2, 0.0, abs(radius - 0.3 - 0.1*vortex));
}

void main(){
    // Transform uv for a chaotic field without obvious symmetry.
    vec2 pos = uv;
    // Apply a non-linear distortion that negates typical radial symmetry.
    pos = vec2(pos.x + 0.15 * sin(4.0 * pos.y + time * 1.5), pos.y + 0.15 * cos(4.0 * pos.x - time * 1.5));
    
    // Base background with oscillating colors driven by noise and time.
    float n = noise(pos * 5.0 + time * 0.5);
    vec3 bgColor = mix(vec3(0.05, 0.1, 0.2), vec3(0.2, 0.3, 0.5), n);
    
    // Create swirling chaotic overlay using higher frequency modulations.
    float chaoticMask = swirlingChaos(pos);
    
    // Dynamic color shifting for chaos: vibrant colors emerging from irregular vortices.
    vec3 chaosColor = vec3(0.8 + 0.2*sin(time + pos.x*10.0), 0.4 + 0.4*cos(time + pos.y*8.0), 0.6 + 0.3*sin(time*0.7 + pos.x*5.0));
    
    // Blend chaotic elements with the background.
    vec3 finalColor = mix(bgColor, chaosColor, chaoticMask);
    
    gl_FragColor = vec4(finalColor, 1.0);
}