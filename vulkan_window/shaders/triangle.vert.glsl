#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(location = 0) in vec3 position;
layout(location = 1) in vec3 normal;
layout(location = 2) in vec2 texCoord;

layout(location = 0) out vec3 fragColor;
layout(location = 1) out vec2 uv;

struct DrawData {
    mat4 model;
    mat4 view;
    mat4 proj;
};

layout(binding = 0, row_major) readonly buffer DrawDataBuffer {
    DrawData drawData;
};


void main() {
    gl_Position = drawData.proj * drawData.view * drawData.model * vec4(position.xyz * vec3(1, 1, -1) - vec3(0, 0.3, 0), 1);
    fragColor = normal * vec3(1, 1, 1) * 0.5 + 0.5;
    uv = texCoord;
}
