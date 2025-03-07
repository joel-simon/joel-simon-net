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
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++){
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

float hourglassShape(vec2 p) {
    // Create an hourglass shape by mirroring an ellipse and subtracting a thin waist
    float ellipse = length(p / vec2(1.0, 1.5));
    float waist = smoothstep(0.02, 0.03, abs(p.x)) * 0.8;
    return smoothstep(0.5, 0.48, ellipse + waist);
}

vec3 waterColor(vec2 p, float t) {
    // Create a flowing water effect using noise and sine waves
    vec2 q = p;
    q.x += fbm(q * 3.0 + t * 0.5) * 0.1;
    q.y += sin(q.x * 10.0 + t) * 0.05;
    float wave = fbm(q * 6.0 - t*0.7);
    vec3 deep = vec3(0.0, 0.1, 0.3);
    vec3 light = vec3(0.2, 0.5, 0.8);
    return mix(deep, light, wave);
}

void main(){
    // Normalize coordinates to center [-1,1]
    vec2 st = uv * 2.0 - 1.0;
    
    // Create a dynamic hourglass shape; the hourglass is usually associated with passing time.
    // Replace the hourglass symbol (S) with water (P), emphasizing the fluidity trait.
    float shape = hourglassShape(st);
    
    // Distort the water pattern with noise to simulate fluid motion inside the hourglass form.
    vec2 waterPos = st * 1.5 + vec2(0.0, sin(time*0.7)*0.1);
    float waterFlow = fbm(waterPos * 2.0 + vec2(time*0.5));
    
    // Modulate water color based on flow and position
    vec3 col = waterColor(waterPos, time);
    col *= smoothstep(0.5, 0.48, waterFlow);
    
    // Blend water effect with out-of-hourglass dark background.
    vec3 background = vec3(0.02, 0.02, 0.05);
    vec3 finalColor = mix(background, col, shape);
    
    gl_FragColor = vec4(finalColor, 1.0);
}