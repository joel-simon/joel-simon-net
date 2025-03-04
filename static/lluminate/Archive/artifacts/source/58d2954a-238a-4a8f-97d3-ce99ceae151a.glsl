precision mediump float;
varying vec2 uv;
uniform float time;

float random (in vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise (in vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void main(){
    // Center and stretch the UV coordinates
    vec2 st = (uv - 0.5);
    st.x *= 1.5;
    
    // Polar coordinates
    float r = length(st);
    float a = atan(st.y, st.x);
    
    // Create a swirling spiral with radial distortion and time evolution.
    float spiral = a + time + 4.0 * r;
    float waves = sin(spiral) + 0.5 * sin(3.0 * spiral);
    
    // Add a layer of subtle noise for extra texture.
    float n = noise(uv * 10.0 + time);
    
    // Blend color channels using sine and cosine for varied phase
    vec3 col;
    col.r = 0.5 + 0.5 * sin(waves + n + 0.0);
    col.g = 0.5 + 0.5 * cos(waves + n + 2.0);
    col.b = 0.5 + 0.5 * sin(waves + n + 4.0);
    
    // Apply a smooth fading function based on radial distance.
    col *= smoothstep(0.7, 0.0, r);
    
    gl_FragColor = vec4(col, 1.0);
}