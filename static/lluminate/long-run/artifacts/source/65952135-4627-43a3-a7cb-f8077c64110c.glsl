precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for noise.
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// 2D noise function.
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(mix(hash(i + vec2(0.0,0.0)), 
                   hash(i + vec2(1.0,0.0)), u.x),
               mix(hash(i + vec2(0.0,1.0)), 
                   hash(i + vec2(1.0,1.0)), u.x), u.y);
}

// Function to create a wrinkled brain-like pattern.
float brainShape(vec2 st) {
    // Adjust proportions for an elliptical shape.
    st.x *= 1.3;
    // Base ellipse.
    float ellipse = smoothstep(0.45, 0.44, dot(st, st));
    
    // Add noise to simulate brain wrinkles.
    float wrinkles = noise(st * 8.0 + time * 0.5);
    wrinkles = smoothstep(0.4, 0.6, wrinkles);
    
    // Combine the ellipse and the wrinkles.
    return mix(ellipse, wrinkles, 0.3);
}

void main() {
    // Normalize uv to center.
    vec2 st = uv * 2.0 - 1.0;
    
    // Create dynamic turbulent background with noise and swirling patterns.
    float rad = length(st);
    float angle = atan(st.y, st.x);
    
    // Swirling pattern affected by time.
    float swirl = sin(6.0 * rad - time * 1.8 + angle);
    float dynamicNoise = noise(st * 4.0 + time);
    float backgroundPattern = mix(swirl, dynamicNoise, 0.5);
    
    // Background color: cosmic twilight.
    vec3 bgColor = mix(vec3(0.05, 0.05, 0.15), vec3(0.1, 0.05, 0.1), backgroundPattern);
    
    // Creative Strategy:
    // We identify the key trait as intellect/wisdom.
    // Traditionally a lightbulb symbolizes ideas.
    // Here we replace the lightbulb (symbol) with a brain (subject) in a context where intellect is essential to navigate chaos.
    // We create a central brain shape with dynamic wrinkles.
    
    // Adjust coordinates for brain placement and deformation.
    vec2 brainCoord = st;
    brainCoord.y *= 1.2;
    float bShape = brainShape(brainCoord);
    
    // Color for the brain: a mix of soft pink and purple.
    vec3 brainColor = vec3(0.8, 0.5, 0.6) * (1.0 - bShape);
    
    // Merge brain shape on top of the swirling background.
    vec3 color = mix(bgColor, brainColor, smoothstep(0.45, 0.4, dot(brainCoord, brainCoord)));
    
    gl_FragColor = vec4(color, 1.0);
}