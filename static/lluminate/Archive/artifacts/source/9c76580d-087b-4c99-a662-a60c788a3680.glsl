precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void main(){
    // Center coordinates and apply slight zoom
    vec2 p = (uv - 0.5) * 2.0;
    
    // Apply polar warp: convert to polar coordinates, change angle and radius using time
    float r = length(p);
    float theta = atan(p.y, p.x);
    theta += sin(r * 4.0 - time * 2.0) * 0.5;
    r = pow(r, 1.2);
    p = vec2(r * cos(theta), r * sin(theta));
    
    // Create a layered fractal noise pattern with iterations and time evolution
    float accum = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    vec2 shift = vec2(time * 0.3, time * -0.2);
    for (int i = 0; i < 6; i++){
        float n = noise(p * frequency + shift);
        accum += n * amplitude;
        frequency *= 2.0;
        amplitude *= 0.5;
    }
    
    // Generate a color palette based on the accumulated noise and original radius
    vec3 colorA = vec3(0.5 + 0.5 * sin(time + accum * 5.0), 0.4 + 0.6 * cos(time + r * 3.0), 0.7 + 0.3 * sin(time - r * 4.0));
    vec3 colorB = vec3(0.9 * noise(p * 2.0 - shift), 0.2 + 0.5 * noise(p * 3.0 + shift), 0.4 + 0.4 * noise(p * 4.0));
    
    // Blend based on a smooth radial mask
    float mask = smoothstep(0.0, 1.0, 1.0 - r);
    vec3 finalColor = mix(colorB, colorA, mask);
    
    gl_FragColor = vec4(finalColor, 1.0);
}