precision mediump float;
varying vec2 uv;
uniform float time;

float noise(vec2 p){
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void main(){
    // Instead of centering the coordinates, we work directly with uv,
    // then intentionally perturb them to reverse typical symmetry assumptions.
    vec2 shiftedUV = uv;
    shiftedUV += 0.1 * sin(10.0 * shiftedUV.yx + time); // introduce asymmetric, time-driven distortion

    // Generate varying noise-based values for each color channel, breaking conventional uniformity
    float r = noise(shiftedUV * 15.0 + vec2(1.0, 2.0) * time);
    float g = noise(shiftedUV * 15.0 + vec2(3.0, 4.0) * time);
    float b = noise(shiftedUV * 15.0 + vec2(5.0, 6.0) * time);
    
    // Mix color channels in a non-uniform, glitchy way
    vec3 color = vec3(r, g, b);
    color = smoothstep(0.3, 0.7, color);
    
    gl_FragColor = vec4(color, 1.0);
}