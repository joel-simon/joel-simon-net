precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    // Random cryptic directive: "Honor thy error as a hidden intention."
    vec2 centered = uv - 0.5;
    float r = length(centered);
    float angle = atan(centered.y, centered.x);
    
    // Introduce an "error" distortion using pseudo random noise.
    float noise = pseudoNoise(centered * 10.0 + time);
    float distortion = sin(time + angle * 5.0) * noise;
    
    // Transform polar coordinates by adding error to the radius.
    float modR = r + distortion * 0.1;
    
    // Create an unexpected spiral by distorting the angle.
    float modAngle = angle + 2.0 * noise * sin(time + modR * 10.0);
    
    // Generate a spiral pattern.
    float spiral = sin(modAngle * 7.0 + modR * 20.0 - time * 3.0);
    float spiralMask = smoothstep(0.3, 0.35, abs(modR - 0.5) + spiral * 0.1);
    
    // Blend colors based on the distorted coordinates.
    vec3 baseColor = vec3(0.1, 0.2, 0.3);
    vec3 highlightColor = vec3(1.0, 0.8, 0.5);
    float mixFactor = smoothstep(0.4, 0.6, modR) + 0.3 * pseudoNoise(vec2(modAngle, modR));
    vec3 color = mix(baseColor, highlightColor, mixFactor);
    
    // Introduce occasional glitches based on error.
    float glitch = step(0.97, pseudoNoise(vec2(time, modAngle * 3.0)));
    color += glitch * vec3(0.5, 0.1, 0.7);
    
    gl_FragColor = vec4(color * spiralMask, 1.0);
}