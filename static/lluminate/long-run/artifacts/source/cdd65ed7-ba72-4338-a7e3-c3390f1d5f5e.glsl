precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Convert uv to centered coordinates
    vec2 centered = uv - 0.5;
    float r = length(centered) * 2.0;
    float a = atan(centered.y, centered.x);
    
    // Creative concept: Transform a universal symbol of "clock" (time) into a dynamic "butterfly"
    // where its wings (traditionally representing the hands of a clock) transform into organic petals.
    // Here, we use repeated sine waves to form petal-like structures.
    
    // Generate petal pattern using modified polar coordinates.
    float petals = sin(8.0 * a + time * 2.0) + cos(5.0 * a - time * 1.5);
    float petalMask = smoothstep(0.45, 0.5, r + 0.2 * petals);
    
    // Create an inner glow that simulates the energetic pulse of transformation.
    float innerGlow = smoothstep(0.0, 0.3, r);
    
    // Color blending: shifting from deep violet (transformation) at center to radiant orange at edges.
    vec3 innerColor = vec3(0.3, 0.0, 0.5);
    vec3 outerColor = vec3(1.0, 0.5, 0.0);
    
    // Modify colors slightly with swirling phase for dynamic feel.
    float phase = sin(time + a * 3.0);
    vec3 color = mix(innerColor, outerColor, innerGlow + 0.5 * phase);
    
    // Final mix with the petal mask to create a delicate, animated butterfly effect.
    gl_FragColor = vec4(color * petalMask, 1.0);
}