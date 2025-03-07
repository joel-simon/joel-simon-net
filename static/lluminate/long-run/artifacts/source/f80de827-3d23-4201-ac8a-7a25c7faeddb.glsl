precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 13758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

void main(void) {
    // Transform uv to centered coordinates [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Compute polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Reverse and modify radius to create vortex and glitch distortion
    float invRadius = 1.0 / (radius + 0.001);
    
    // Combine dynamic swirling: add a time based offset plus glitch noise
    float angleOffset = time * 0.7;
    float glitchOffset = noise(vec2(uv.y * 10.0, time)) * 0.5;
    float dynamicAngle = angle + angleOffset + glitchOffset;
    
    // Recreate vortex effect with reverse radial mapping
    vec2 vortexPos = vec2(cos(dynamicAngle), sin(dynamicAngle)) * invRadius;
    
    // Introduce smooth noise based distortions in vortex space
    float n = noise(vortexPos * 3.0 + time);
    vortexPos += vec2(n * 0.2, n * -0.2);
    
    // Generate a pulsating heart mask using a polar equation
    float heart = smoothstep(0.42, 0.40, abs(pow(radius, 0.5) - sin(angle * 3.0 + time * 2.0) * 0.5));
    
    // Create a dynamic ring layer that pulsates with time
    float ring = smoothstep(0.22, 0.23, abs(radius - 0.5 - 0.2 * sin(time * 1.5)));
    
    // Build a color gradient blending a warm and cool palette based on dynamicAngle
    vec3 warmColor = vec3(1.0, 0.5, 0.2);
    vec3 coolColor = vec3(0.2, 0.5, 1.0);
    vec3 gradientColor = mix(warmColor, coolColor, (sin(dynamicAngle + time) + 1.0) * 0.5);
    
    // Enhance with an added vortex based color modulation using cosine
    float grad = smoothstep(-1.0, 1.0, cos(dynamicAngle + time));
    vec3 vortexColor = mix(gradientColor, vec3(0.9, 0.4, 0.1), grad);
    
    // Combine all elements: vortex swirl, heart mask, and pulsating ring effect with glitch detail
    vec3 finalColor = vortexColor * (1.0 - heart);
    finalColor = mix(finalColor, vec3(1.0, 1.0, 1.0), ring);
    finalColor += noise(uv * 15.0 + time) * 0.1;
    
    gl_FragColor = vec4(finalColor, 1.0);
}