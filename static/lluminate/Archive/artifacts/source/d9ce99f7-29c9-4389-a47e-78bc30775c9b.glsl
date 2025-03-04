precision mediump float;
varying vec2 uv;
uniform float time;

void main(){
    // Center uv and scale it
    vec2 pos = (uv - 0.5) * 2.0;
    float r = length(pos);
    float angle = atan(pos.y, pos.x);

    // Create a time-evolving twist based on distance
    float twist = sin(r * 10.0 - time * 3.0) * 0.5;
    angle += twist;

    // Generate a spiral pattern from the modified polar coordinate
    float spiral = fract(angle / (3.14159) + time * 0.5);

    // Create layered radial bands varying with time and distance
    float bands = fract(r * 12.0 - time);
    float mixPattern = mix(bands, spiral, 0.5);
    mixPattern = smoothstep(0.3, 0.7, mixPattern);

    // Additional wave pattern for color modulation
    float wave = sin(time + r * 20.0) * 0.5 + 0.5;

    // Dynamic color palette mixing two complex color combinations
    vec3 color1 = vec3(0.5 + 0.5 * cos(time + angle), 0.5 + 0.5 * sin(time + r * 10.0), 0.7 + 0.3 * cos(time - r * 5.0));
    vec3 color2 = vec3(0.9, 0.4, 0.6) * wave;
    
    vec3 finalColor = mix(color1, color2, mixPattern);

    gl_FragColor = vec4(finalColor, 1.0);
}