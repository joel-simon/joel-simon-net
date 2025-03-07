precision mediump float;
varying vec2 uv;
uniform float time;

float butterflyShape(vec2 p) {
    // Center coordinates
    p = (p - 0.5) * 2.0;
    // Rotate the coordinate system slowly over time
    float angle = atan(p.y, p.x) + 0.5 * sin(time);
    float radius = length(p);
    
    // Create a petaled effect using the sine function, mimicking butterfly wings
    float petals = abs(sin(3.0 * angle));
    
    // The ideal distance from center to edge of a wing varies with angle (petals pattern)
    float ideal = mix(0.4, 0.7, petals);
    
    // Compute the difference between current radius and ideal wing edge
    float diff = radius - ideal;
    // Smooth transition for the shape boundary
    return 1.0 - smoothstep(0.0, 0.02, diff);
}

void main() {
    // Background: a soft gradient shifting with time to set an ambient mood
    vec2 center = vec2(0.5, 0.5);
    float dist = length(uv - center);
    vec3 bgColor = mix(vec3(0.1, 0.15, 0.3), vec3(0.05, 0.05, 0.1), smoothstep(0.2, 0.6, dist));
    
    // Generate a butterfly-like shape which replaces a symbol (traditionally a cocoon)
    // in a context where transformation is essential.
    float shape = butterflyShape(uv);
    
    // Color for the butterfly: a gradient from deep violet near the body to soft magenta at the wings
    vec3 bodyColor = vec3(0.3, 0.0, 0.5);
    vec3 wingColor = vec3(0.7, 0.2, 0.8);
    float blendFactor = smoothstep(0.0, 1.0, (uv.y - 0.4));
    vec3 butterflyColor = mix(bodyColor, wingColor, blendFactor);
    
    // Introduce a subtle flicker effect with a sine modulation of time
    butterflyColor *= (0.8 + 0.2 * sin(time * 3.0));
    
    // Composite the butterfly shape atop the background
    vec3 color = mix(bgColor, butterflyColor, shape);
    
    gl_FragColor = vec4(color, 1.0);
}