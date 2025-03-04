precision mediump float;
varying vec2 uv;
uniform float time;

// Simple 2D hash function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// 2D noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    
    // Four corners in 2D of our cell
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    
    // Smooth interpolation
    vec2 u = f*f*(3.0-2.0*f);
    
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b)* u.x * u.y;
}

void main(){
    // Center UV coordinates around (0,0) and scale.
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Convert Cartesian to polar
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Create a twist effect by modifying the angle with noise and time
    float n = noise(vec2(r * 3.0, time * 0.5));
    angle += n * 3.1415 * 0.5;
    
    // Reconstruct the coordinates with the new angle
    vec2 twisted = vec2(r * cos(angle), r * sin(angle));
    
    // Create a secondary layer of distortion based on iterative noise sampling
    float distort = 0.0;
    vec2 samplePos = twisted;
    for (int i = 0; i < 3; i++){
        distort += noise(samplePos * (1.0 + float(i)*0.5) + time);
        samplePos *= 1.5;
    }
    distort = distort / 3.0;
    
    // Color based on radial distance, twist and time.
    vec3 col;
    col.r = sin(3.0 * twisted.x + time + distort * 3.0) * 0.5 + 0.5;
    col.g = cos(4.0 * twisted.y + time * 1.5 + distort * 2.0) * 0.5 + 0.5;
    col.b = sin(5.0 * r - time + distort * 4.0) * 0.5 + 0.5;
    
    // Apply vignette effect for depth
    float vignette = smoothstep(0.8, 0.0, r);
    col *= vignette;
    
    gl_FragColor = vec4(col, 1.0);
}