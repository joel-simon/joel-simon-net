precision mediump float;
varying vec2 uv;
uniform float time;

//
// Combined Creative Shader:
// "Honor thy error as a hidden intention" directive inspires us to embrace glitch and randomness.
// This shader blends dynamic wing-like phoenix modulation with ripple-like ocean effects,
// using polar coordinates and normalized UV space transformation to create unexpected, evolving visual art.
//

// Pseudo random function
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

// 2D noise based on simple interpolation
float noise(vec2 p){
    vec2 ip = floor(p);
    vec2 u = fract(p);
    u = u*u*(3.0-2.0*u);
    float res = mix(
                   mix(rand(ip),rand(ip+vec2(1.0,0.0)),u.x),
                   mix(rand(ip+vec2(0.0,1.0)),rand(ip+vec2(1.0,1.0)),u.x),u.y);
    return res;
}

void main(void) {
    // Transform uv to [-1,1] coordinate space.
    vec2 pos = uv * 2.0 - 1.0;
    
    // Convert Cartesian coordinates to polarized view.
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Phoenix wing modulation using sine functions.
    float wing = sin(angle * 4.0 + time * 2.0) * 0.3;
    float shapePhoenix = smoothstep(0.5 + wing, 0.47 + wing, r);

    // Ocean ripple effect: radial ripple modified by sine functions.
    float ripple = sin(10.0 * r - time * 4.0);
    float twist = cos(angle * 3.0 + time) * 0.5;
    float maskOcean = smoothstep(0.45 + twist, 0.4 + twist, r + ripple * 0.05);
    
    // Combine both effects using a glitch directive:
    // Embrace errors with a random/noise based glitch factor.
    float glitch = noise(pos * 10.0 + time);
    float glitchMask = smoothstep(0.4, 0.6, glitch);

    // Compose colors for phoenix and ocean.
    vec3 colorPhoenix = vec3(1.0, 0.4 + 0.4 * sin(time + angle), 0.0);
    vec3 colorOcean = vec3(0.0, 0.1, 0.3) * mix(0.8, 1.2, noise(pos * 5.0));
    vec3 mixedColor = mix(colorPhoenix, colorOcean, r);

    // Introduce additional glimmer effects reminiscent of cosmic sparks and lunar shimmer.
    float glimmer = smoothstep(0.48, 0.5, fract(r * 20.0 - time * 3.0));
    mixedColor += glimmer * 0.15;
    
    // Apply the phoenix and ocean masks in a layered, glitch-injected manner.
    vec3 finalColor = mixedColor;
    finalColor *= mix(shapePhoenix, maskOcean, 0.5);
    finalColor = mix(finalColor, vec3(1.0) - finalColor, glitchMask * 0.3);

    gl_FragColor = vec4(finalColor, 1.0);
}