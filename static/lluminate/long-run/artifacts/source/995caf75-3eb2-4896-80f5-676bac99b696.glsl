precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0,0.0)), hash(i + vec2(1.0,0.0)), u.x),
               mix(hash(i + vec2(0.0,1.0)), hash(i + vec2(1.0,1.0)), u.x), u.y);
}

vec2 rotate(vec2 p, float a) {
    float s = sin(a);
    float c = cos(a);
    return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

void main() {
    // Creative Idea:
    // identify_trait: Complexity of thought (creativity)
    // find_symbol: Traditionally a heart is seen as symbol of emotion.
    // create_context: In our digital realm, smooth and rhythmic pulses symbolize life.
    // replace: Here we replace the heart with a brain-like structure,
    //          using fractal noise and swirling patterns to represent dynamic neural networks.
    
    vec2 pos = uv * 2.0 - 1.0;
    
    // Dynamic swirling effect representing neural synapses firing
    float swirl = sin(5.0 * atan(pos.y, pos.x) + time * 2.0);
    
    // Fractal noise layers to simulate brain complexity
    float n = 0.0;
    float scale = 1.0;
    for(int i = 0; i < 4; i++){
        n += noise(pos * scale + time * 0.5) / scale;
        scale *= 2.0;
    }
    
    // Create a shockwave pattern which acts as a trigger for activity
    float r = length(pos);
    float shock = smoothstep(0.3, 0.28, abs(r - 0.5 - 0.1*sin(time*3.0)));
    
    // Combine the components: swirling neural network (brain) replacing the 'heart'
    float brainPulse = mix(swirl, n, 0.5) * (1.0 - shock);
    
    // Color modulation: using a palette that symbolizes thought and electricity
    vec3 colorA = vec3(0.1, 0.2, 0.5);
    vec3 colorB = vec3(0.9, 0.8, 0.4);
    vec3 brainColor = mix(colorA, colorB, brainPulse * 0.5 + 0.5);
    
    // Dynamic vignette to focus on the brain structure
    float vignette = smoothstep(1.0, 0.0, length(pos));
    brainColor *= vignette;
    
    gl_FragColor = vec4(brainColor, 1.0);
}