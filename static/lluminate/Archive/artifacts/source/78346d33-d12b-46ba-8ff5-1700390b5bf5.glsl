precision mediump float;
varying vec2 uv;
uniform float time;

const float PI = 3.14159265;
const int ITER = 10;

// A periodic hash function for pseudo-randomness.
float hash(float n) {
    return fract(sin(n)*43758.5453123);
}

// 2D noise based on hashed grid.
float noise(vec2 x) {
    vec2 i = floor(x);
    vec2 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = i.x + i.y*57.0;
    return mix(mix(hash(n +  0.0), hash(n +  1.0), f.x),
               mix(hash(n + 57.0), hash(n + 58.0), f.x), f.y);
}

// Dynamic recursive warp function adding fractal distortion.
float fractalWarp(vec2 p) {
    float value = 0.0;
    float amplitude = 1.0;
    for (int i = 0; i < ITER; i++) {
        // Create a swirling effect by converting to polar.
        float r = length(p);
        float a = atan(p.y, p.x);
        // Modulate twist by noise and time.
        float twist = sin(a*3.0 + time*0.5 + noise(p*3.0 + time));
        a += twist * 0.5;
        p = vec2(cos(a), sin(a)) * r;
        // Accumulate a sine modulation.
        value += sin(p.x*3.0 + time*0.8) * amplitude;
        // Amplify and distort p for next iteration.
        p = p*1.8 + vec2(sin(time*0.3), cos(time*0.2));
        amplitude *= 0.6;
    }
    return value;
}

// Create vibrant hue shift based on angle and noise.
vec3 colorPalette(float t, float n) {
    float r = 0.5 + 0.5*sin(PI * t + n + 0.0);
    float g = 0.5 + 0.5*sin(PI * t + n + 2.0);
    float b = 0.5 + 0.5*sin(PI * t + n + 4.0);
    return vec3(r, g, b);
}

void main(){
    // Center uv coordinates (-1,1) space.
    vec2 pos = (uv - 0.5) * 2.0;

    // Apply a radial warp that pulsates with time.
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);

    // Extra twist applied for extra dynamic distortion.
    angle += 0.3*sin(3.0*radius - time*1.2);
    pos = vec2(cos(angle), sin(angle)) * radius;

    // Add subtle wave offset to pos.
    pos += vec2(sin(pos.y*4.0 + time), cos(pos.x*4.0 - time))*0.2;

    // Get fractal pattern distortion.
    float pattern = fractalWarp(pos*1.5);

    // Normalize and exaggerate pattern.
    float patternMix = smoothstep(-3.0, 3.0, pattern);

    // Use pattern to shift hues across the screen.
    vec3 col = colorPalette(angle/PI + 0.5, pattern * 0.8);

    // Blend in a shifting dark vignette from the edges.
    float vig = smoothstep(0.8, 0.0, radius);
    col *= vig;

    gl_FragColor = vec4(col, 1.0);
}