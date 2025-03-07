precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random noise
float noise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

// Reverse the usual assumption of centered symmetry: treat the 
// UV space as inherently chaotic and let the error drive structure.
void main(){
    // Reinterpret the UV coordinates in a non-centered, "chaotic" domain.
    vec2 pos = uv;
    
    // Introduce chaotic distortions: instead of smooth transitions, we use abrupt noise thresholds
    float n = noise(pos * 10.0 + time);
    pos += (n - 0.5) * 0.5; // Impose unexpected jumps
    
    // Create spiraling perturbations that emanate from random points rather than the center.
    vec2 spiralCenter = vec2(0.3 + 0.4 * sin(time * 0.7), 0.3 + 0.4 * cos(time * 0.9));
    vec2 diff = pos - spiralCenter;
    float angle = atan(diff.y, diff.x) + time;
    float radius = length(diff);
    
    // Instead of a smooth spiral, we step the radius so that inner layers jump out.
    float steppedRadius = floor(radius * 8.0) / 8.0;
    float spiral = sin(10.0 * angle + steppedRadius * 20.0);
    
    // Use a glitchy color scheme that deliberately uses unexpected color bursts.
    vec3 col1 = vec3(0.1, 0.6, 0.3);
    vec3 col2 = vec3(0.8, 0.2, 0.7);
    vec3 col3 = vec3(0.9, 0.9, 0.2);
    
    // Mix colors based on spiral and noise contrasts.
    vec3 color = mix(col1, col2, smoothstep(-0.2, 0.2, spiral));
    float glitch = step(0.85, noise(pos * 100.0 + time * 5.0));
    color = mix(color, col3, glitch);
    
    // Increase contrast by using abrupt transitions.
    float mask = step(0.3, abs(spiral));
    color *= mask;
    
    gl_FragColor = vec4(color, 1.0);
}