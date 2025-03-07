precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(17.0, 47.0))) * 239.0);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d){
    return a + b * cos(6.28318 * (c*t + d));
}

void main(){
    vec2 p = uv - 0.5;
    p *= 2.0;
    
    // Use polar coordinates to create a vortex-like twist.
    float r = length(p);
    float theta = atan(p.y, p.x);
    // Reverse assumption: don't let angle directly determine the color.
    // Instead, peturb angle with noise interfered by radius.
    float n = noise(vec2(r*3.0, time*0.3));
    theta += n * 3.1416;
    
    // Create a ripple effect based on polar distance.
    float ripple = sin(10.0 * r - time * 3.0);
    float mask = smoothstep(0.3, 0.4, abs(ripple));
    
    // Render a surprising glitch by displacing the radial coordinate at intervals.
    float glitch = step(0.98, random(vec2(r, sin(time))));
    r += glitch * 0.2 * sin(50.0 * theta);
    
    vec2 newPos = vec2(r * cos(theta), r * sin(theta));
    
    // Generate a layered color pattern by merging polar transformation with a shifting palette.
    float colMix = smoothstep(0.0, 1.0, r + 0.3 * noise(newPos * 4.0 + time));
    vec3 color1 = palette(colMix, vec3(0.5), vec3(0.5), vec3(1.0, 0.5, 0.3), vec3(0.0,0.33,0.67));
    vec3 color2 = vec3(0.1, 0.05, 0.2) + 0.5 * vec3(sin(time+newPos.x*10.0), cos(time+newPos.y*10.0), sin(time+newPos.x*10.0+newPos.y*10.0));
    
    vec3 col = mix(color1, color2, mask);
    
    gl_FragColor = vec4(col, 1.0);
}