precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Anchor concept: dynamic swirling organic patterns.
    // Shift uv coordinates to center and scale.
    vec2 p = (uv - 0.5) * 2.0;
    
    // Generate a rotating angle based on time (anchor: swirl)
    float angle = time * 0.5;
    float c = cos(angle);
    float s = sin(angle);
    mat2 rotation = mat2(c, -s, s, c);
    p = rotation * p;
    
    // Convert to polar coordinates for organic petal-like pattern
    float r = length(p);
    float a = atan(p.y, p.x);
    
    // Generate a medium-distance association: petal pattern using a mix of sine and cosine waves
    float petals = sin(8.0 * a + time * 2.0) + cos(5.0 * a - time * 1.5);
    float petalMask = smoothstep(0.45, 0.5, r + 0.2 * petals);
    
    // Generate dynamic swirling effect using sine wave combinations for color transitions
    float swirl = sin(10.0 * p.x + time) + sin(10.0 * p.y + time);
    
    // Create dual color themes: inner organic glow and outer vibrant contrast
    vec3 innerColor = vec3(0.3, 0.0, 0.6);
    vec3 outerColor = vec3(1.0, 0.6, 0.2);
    
    // Mix colors based on radial distance with additional dynamic modulation
    float mixValue = smoothstep(0.0, 1.0, r + 0.3 * swirl);
    vec3 color = mix(innerColor, outerColor, mixValue);
    
    // Final connection: modulate with petal pattern to emphasize organic shape
    gl_FragColor = vec4(color * petalMask, 1.0);
}