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
    
    return mix(a, b, u.x) + (c - a)*u.y*(1.0-u.x) + (d - b)*u.x*u.y;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for(int i = 0; i < 6; i++){
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 swirl(vec2 st, float strength) {
    float radius = length(st);
    float angle = atan(st.y, st.x) + strength * exp(-radius * 3.0);
    return vec2(cos(angle), sin(angle)) * radius;
}

vec2 digitalDisrupt(vec2 st, float t) {
    // Introduce a digital fragmentation by displacing parts of the image.
    float amt = smoothstep(0.4, 0.0, abs(sin(t + st.y * 10.0))) * 0.03;
    st.x += amt * sin(50.0 * st.y + t);
    return st;
}

vec3 invertedDigital(vec2 st) {
    // Create an inverted color digital matrix style.
    float grid = step(0.98, fract(st.x * 20.0 + fbm(st*3.0 + time)));
    vec3 base = mix(vec3(0.1,0.1,0.1), vec3(0.9,0.9,0.9), grid);
    return base;
}

vec3 cosmicReversal(vec2 st) {
    // Reverse the organic assumption by turning natural swirling into cold, digital cosmos.
    vec2 centered = st - 0.5;
    centered = swirl(centered, time * 0.5);
    centered = digitalDisrupt(centered, time);
    float intensity = fbm(centered * 8.0 + time);
    vec3 col = mix(vec3(0.0,0.1,0.3), vec3(0.2,0.7,1.0), intensity);
    return col;
}

void main(){
    vec2 pos = uv;
    vec3 digital = invertedDigital(pos);
    vec3 cosmic = cosmicReversal(pos);
    
    // Mix more digital over the cosmic, with a dynamic, unexpected interplay
    float mixVal = smoothstep(0.3, 0.7, fbm(pos*5.0 - time));
    vec3 finalColor = mix(cosmic, digital, mixVal);
    
    gl_FragColor = vec4(finalColor, 1.0);
}