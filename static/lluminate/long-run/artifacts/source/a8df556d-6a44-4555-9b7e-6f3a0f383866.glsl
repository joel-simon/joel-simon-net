precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function based on sine
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

// 2D noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void main(void) {
    // Map uv from [0,1] to [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Convert Cartesian coords to polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Anchor concept: A radiant star or cosmic vortex.
    // Generate medium-distance association with swirling vortex elements.
    
    // Starburst element: modulating bursts based on angle and time.
    float bursts = abs(cos(8.0 * angle + time * 2.0));
    float starShape = smoothstep(0.4, 0.38, radius) * bursts;
    
    // Vortex element: swirl distorted noise across the field.
    float swirl = sin(angle * 4.0 + time * 1.5);
    float vortex = smoothstep(0.6, 0.4, radius + swirl * 0.3);
    
    // Organic noise to add texture and cosmic dust effect.
    float cosmicNoise = noise(pos * 3.0 + time * 1.5);
    float distortion = smoothstep(0.0, 1.0, cosmicNoise * 1.2);
    
    // Color gradient: warm radiant core blended with cold outer space hues.
    vec3 warmColor = mix(vec3(0.9, 0.7, 0.2), vec3(1.0, 0.9, 0.5), distortion);
    vec3 coolEdge = mix(warmColor, vec3(0.1, 0.2, 0.5), smoothstep(0.3, 0.7, radius));
    
    // Combine starburst with vortex distortion
    vec3 combinedColor = mix(coolEdge, vec3(1.0, 1.0, 0.8), starShape);
    combinedColor = mix(combinedColor, vec3(0.2, 0.4, 0.8), vortex);
    
    gl_FragColor = vec4(combinedColor, 1.0);
}