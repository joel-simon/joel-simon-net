precision mediump float;
varying vec2 uv;
uniform float time;

float noise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

void main(){
    // Center the coordinate system
    vec2 pos = uv - 0.5;
    
    // Create polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Define the "brain" pattern by replacing the traditional heart symbol.
    // Instead of a heart, we form a rhythmic, lobed pattern that represents brain activity.
    // The lobes pulse and shift with time, symbolizing intellect and creativity.
    float lobes = 4.0; // number of lobes
    float brainPattern = sin(lobes * angle + time) * cos(3.0 * radius * 6.2831 - time * 2.0);
    
    // Create a soft mask that defines the rough outline of a brain shape
    // Instead of a heart mask, use the interplay of sine waves in radius.
    float brainMask = smoothstep(0.3, 0.25, radius + 0.15 * abs(brainPattern));
    
    // Introduce a subtle noise for texture
    float n = noise(pos * 12.0 + time);
    float texture = smoothstep(0.4, 0.6, n);
    
    // Mix vibrant colors that symbolize neural activity
    vec3 baseColor = vec3(0.1, 0.1, 0.2);
    vec3 activityColor = vec3(0.8, 0.4, 0.2);
    vec3 pulseColor = vec3(0.2, 0.7, 0.9);
    
    // Color modulation based on the brain pattern and noise texture
    vec3 color = mix(baseColor, activityColor, brainMask);
    color = mix(color, pulseColor, texture * 0.5);
    
    // Add an oscillatory intensity modulation to emphasize pulsation
    float pulse = smoothstep(0.0, 0.5, abs(sin(time + radius * 10.0)));
    color += pulse * vec3(0.1, 0.1, 0.1);
    
    gl_FragColor = vec4(color, 1.0);
}