precision mediump float;
varying vec2 uv;
uniform float time;

// A function to generate a dynamic, rotating, and bouncing pattern based on polar coordinates.
float polarPattern(vec2 p) {
    // Center the coordinate system to [-1, 1]
    p = 2.0 * (p - 0.5);
  
    // Convert Cartesian to polar coordinates.
    float r = length(p);
    float a = atan(p.y, p.x);
  
    // Reverse and bounce the pattern using sine functions.
    float angleMod = sin(a * 3.0 + time * 1.5);
    float radiusMod = cos(time + r * 10.0);
  
    // Combine operations: substitute structured grid with swirling polar distortions.
    float pattern = smoothstep(0.4 + 0.1 * angleMod, 0.35, r + 0.05 * radiusMod);
  
    return pattern;
}

void main() {
    // Apply a dynamic background using shifting radial colors.
    vec2 center = vec2(0.5, 0.5);
    float dist = length(uv - center);
    vec3 bgColor = mix(vec3(0.1, 0.05, 0.2), vec3(0.0, 0.5, 0.7), smoothstep(0.0, 0.8, dist));
  
    // Generate a transformed pattern replacing the original tree concept.
    float pattern = polarPattern(uv);
  
    // Mix two vibrant color schemes based on the pattern dynamics.
    vec3 primaryColor = vec3(1.0, 0.8, 0.2);
    vec3 secondaryColor = vec3(0.9, 0.3, 0.8);
    vec3 patternColor = mix(primaryColor, secondaryColor, pattern);
  
    // Blend the pattern onto the background, emphasizing the dynamic effect.
    vec3 finalColor = mix(bgColor, patternColor, pattern);
  
    gl_FragColor = vec4(finalColor, 1.0);
}