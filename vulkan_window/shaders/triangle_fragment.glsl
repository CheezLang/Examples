#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(location = 0) out vec4 outColor;

layout(location = 0) in vec3 fragColor;
layout(location = 1) in vec2 uv;

#define EPSILON 0.001
#define MAX_STEPS 500
#define MAX_DIST 100
#define PI 3.1415

mat3 rotX(float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return mat3(
        1, 0, 0,
        0, c, -s,
        0, s, c
    );
}

mat2 rot2d(float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return mat2(
        c, -s,
        s, c
    );
}

float sdCircle(vec2 pos, float radius) {
    return length(pos) - radius;
}

float sdQuad(vec2 pos, vec2 size) {
    vec2 clamped = clamp(pos, -size, size);
    return length(pos - clamped);
}

float sdSphere(vec3 pos, float radius) {
    return length(pos) - radius;
}

vec3 circle3d(vec3 pos, float radius) {
    return vec3(length(pos.xz) - radius, pos.y, atan(pos.x, pos.z));
}

float sdTorus(vec3 pos, float radius1, float radius2) {
    vec2 uv = vec2(length(pos.xz) - radius1, pos.y);
    return sdCircle(uv, radius2);
}

float getDist(vec3 pos) {
    pos = rotX(-PI/4) * (pos - vec3(0, -1.5, 7));
    vec3 uv = circle3d(pos, 2.0);

    // uv.xy = uv.xy + vec2(1, 0);
    uv.xy = rot2d(uv.z * 2.5) * uv.xy;
    uv.y = abs(uv.y) - 0.75;

    // return sdCircle(uv.xy, 0.5) * 0.2;
    return (sdQuad(uv.xy, vec2(0.5, 0.125)) - 0.1) * 0.12;
}

vec3 getNormal(vec3 p) {
    float d = getDist(p);
    vec2 e = vec2(.01, 0);
    
    vec3 n = d - vec3(
        getDist(p-e.xyy),
        getDist(p-e.yxy),
        getDist(p-e.yyx));
    
    return normalize(n);
}

float rayMarch(vec3 pos, vec3 dir) {
    float t = 0;
    for (int i = 0; i < MAX_STEPS; i++) {
        float dist = getDist(pos + dir * t);
        if (dist <= EPSILON)
            return t;
        t += dist;
        if (t >= MAX_DIST)
            return -1;
    }

    return -1;
}

vec3 rayDir(vec2 uv) {
    vec3 forward = vec3(0, 0, 1);
    return normalize(vec3(uv, 1));
}

vec3 background(vec3 dir) {
    vec3 bottom = vec3(0.8, 0.6, 0.4);
    vec3 top = vec3(0.4, 0.6, 0.8);
    return mix(bottom, top, dir.y);
}

void main() {
    vec2 uv = uv * 2 - 1;
    vec3 color = vec3(0);

    vec3 camPos = vec3(0);
    vec3 camDir = rayDir(uv);
    vec3 lightPos = vec3(3, 3, 1);

    float t = rayMarch(camPos, camDir);

    if (t > 0) {
        vec3 hit = camPos + camDir * t;
        vec3 normal = getNormal(hit);
        
        vec3 lightDir = normalize(lightPos - hit);

        float diffuseFactor = max(dot(normal, lightDir), 0.05);

        vec3 reflectedLightDir = reflect(lightDir, normal);
        vec3 reflectedCamDir = reflect(camDir, normal);

        float specularFactor = pow(max(dot(reflectedLightDir, camDir), 0), 16);

        color += diffuseFactor * 0.8 + specularFactor + 0.2 * background(reflectedCamDir);
    } else {
        color += background(camDir);
    }

    outColor = vec4(color, 1);
}