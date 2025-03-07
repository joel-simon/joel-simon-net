precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(7.23, 18.17))) * 43758.5453);
}

float voronoi(vec2 st) {
    vec2 i_st = floor(st);
    vec2 f_st = fract(st);
    float mDist = 1.0;
    for (int j = -1; j <= 1; j++)
    for (int i = -1; i <= 1; i++) {
        vec2 neighbor = vec2(float(i), float(j));
        vec2 point = pseudoRandom(i_st + neighbor) * vec2(0.5, 0.5) + 0.25;
        vec2 diff = neighbor + point - f_st;
        float dist = length(diff);
        mDist = min(mDist, dist);
    }
    return mDist;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for(int i = 0; i < 5; i++){
        value += amplitude * voronoi(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 reverseGlitch(vec2 pos, float t) {
    // Reverse expectation: instead of slight glitch, use reversing UV distortion.
    float glitchFactor = smoothstep(0.3, 0.0, abs(sin(t * 2.0)))*0.05;
    pos.y -= glitchFactor * sin(pos.x * 50.0 + t);
    pos.x += glitchFactor * cos(pos.y * 50.0 - t);
    return pos;
}

void main(){
    // Invert typical organic assumptions: begin from a fragmented, disintegrated grid
    vec2 centeredUV = uv - 0.5;
    
    // Instead of smooth polar transform, we gradually disassemble coordinates
    float fbmVal = fbm(centeredUV * 3.0 + time);
    float rotation = (0.5 - fbmVal) * 6.2831;
    float c = cos(rotation);
    float s = sin(rotation);
    mat2 rot = mat2(c, -s, s, c);
    vec2 distortedUV = rot * centeredUV;
    
    // Apply reversed glitch effects altering the standard expectation
    vec2 glitchUV = reverseGlitch(distortedUV, time);
    
    // Construct an unnatural background using fractal noise with reversed gradients
    float noiseValue = fbm(glitchUV * 4.0 - time);
    vec3 baseColor = vec3(0.7 - noiseValue, 0.3 + noiseValue, 0.5 - noiseValue * 0.5);
    
    // Create discontinuous digital artifacts
    vec2 grid = fract(glitchUV * 20.0);
    float line = step(0.1, min(grid.x, grid.y));
    vec3 digital = vec3(line * 0.2, line * 0.1, line * 0.3);
    
    // Invert typical blending by subtracting digital from organic based on distance from center
    float radius = length(centeredUV);
    float blend = smoothstep(0.4, 0.1, radius);
    vec3 color = baseColor - digital * blend;
    
    // Incorporate sharp glitch bursts based on reversed assumptions: darker rather than brighter
    float burst = step(0.98, pseudoRandom(glitchUV * time)) * 0.3;
    color -= burst;
    
    gl_FragColor = vec4(color, 1.0);
}