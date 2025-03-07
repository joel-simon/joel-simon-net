precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

void main(){
    // Reverse assumption: instead of continuous smooth motion, we use sudden static frozen patterns that evolve unpredictably.
    vec2 pos = uv * 2.0 - 1.0;
    pos.x *= 1.5;
    
    // Instead of using uniformly swirling waves, we create segmented static regions that "freeze" their motion for brief moments.
    float region = floor(5.0 * pos.x) + floor(5.0 * pos.y);
    float freeze = step(0.5, fract(region*0.3333 + time*0.2));
    
    // Invert typical smooth dynamic feedback: use random impulses within each region.
    float impulse = random(floor(pos * 5.0) + vec2(time));
    
    // Compute radius and angle normally to introduce a hint of global structure.
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Create a stark static pattern instead of continuous swirling: use sharp functions and static noise.
    float pattern = step(0.5, sin(10.0 * radius + impulse * 6.28 + angle * 3.0));
    
    // Blend between static frozen segments and a decaying background that updates slowly.
    float mixFactor = mix(pattern, freeze, 0.5);
    
    // Color mixing based on reversed assumptions:
    // Instead of blending dynamic gradients, use abrupt contrasting colors modulated by the impulse.
    vec3 colorA = vec3(0.1, 0.9, 0.3) * mixFactor;
    vec3 colorB = vec3(0.9, 0.2, 0.7) * (1.0 - mixFactor);
    vec3 finalColor = mix(colorA, colorB, smoothstep(0.2, 0.8, radius));
    
    // Add a glitch-like artifact by multiplying with a staccato noise pattern.
    float glitch = random(pos * (time * 0.5));
    finalColor += glitch * 0.15;
    
    gl_FragColor = vec4(finalColor,1.0);
}