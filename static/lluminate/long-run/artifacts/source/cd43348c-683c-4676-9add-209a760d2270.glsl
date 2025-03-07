precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 co) {
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

void main(){
    // Step 1: draw_random_card - "Honor thy error as a hidden intention"
    // Step 2: interpret_directive - Let glitches and erroneous lines be the intentional motif.
    // Step 3: apply_insight - Create a shader that intentionally glitches the color channels and spatial coordinates.
    
    // Base coordinate manipulation: center uv around (0,0)
    vec2 p = (uv - 0.5) * 2.0;
    
    // Generate glitch offsets using noise and time
    float glitchStrength = 0.15;
    vec2 glitchOffset = vec2(noise(p * 12.0 + time * 2.0), noise(p * 12.0 - time * 2.0)) - 0.5;
    p += glitchStrength * glitchOffset;
    
    // Introduce deliberate channel misalignment using separate noise for each color channel
    float r = noise(p * 3.0 + vec2(time,0.0));
    float g = noise(p * 3.0 + vec2(0.0,time));
    float b = noise(p * 3.0 + vec2(time*0.5, time*0.5));
    
    // Create scanline artifact: horizontal lines that "error" across the screen
    float scan = smoothstep(0.0, 0.02, abs(fract(uv.y * 50.0 + time * 5.0) - 0.5));
    vec3 scanColor = vec3(0.8, 0.8, 0.8) * scan * 0.3;
    
    // Color offset: mix color channels with glitch pattern using a sine wave
    float shift = sin(time * 3.1415 + uv.x * 10.0) * 0.1;
    vec3 col = vec3(
        r + shift,
        g - shift,
        b + 0.5 * shift
    );
    
    // Introduce a subtle background gradient error effect
    vec3 bg = vec3(0.1, 0.05, 0.15) + 0.25 * vec3(uv.y, uv.x, 1.0 - uv.y);
    
    // Mix glitch intentional color with the background based on a noise threshold.
    float mixFactor = smoothstep(0.3, 0.7, noise(uv * 15.0 + time));
    vec3 finalColor = mix(bg, col, mixFactor) + scanColor;
    
    // Final intentional error: artificially saturate the red channel in some areas
    float redError = step(0.95, rand(uv * 100.0 + time));
    finalColor.r += redError * 0.3;
    
    gl_FragColor = vec4(finalColor, 1.0);
}