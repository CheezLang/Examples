#version 450
#extension GL_ARB_separate_shader_objects : enable

struct Vertex {
    vec4 position;
    vec4 normal;
    vec4 texCoord;
};

struct DrawData {
    mat4 model;
    mat4 view;
    mat4 proj;
};

layout(set = 0, binding = 0, row_major) uniform DrawDataBuffer {
    DrawData drawData;
};

layout(set = 1, binding = 0) readonly buffer VertexBuffer {
    Vertex vertices[];
};

layout(location = 0) out vec3 fragColor;
layout(location = 1) out vec2 uv;

void main() {
    vec3 position = vertices[gl_VertexIndex].position.xyz;
    vec3 normal = vertices[gl_VertexIndex].normal.xyz;
    vec2 texCoord = vertices[gl_VertexIndex].texCoord.xy;

    gl_Position = drawData.proj * drawData.view * drawData.model * vec4(position.xyz * vec3(1, 1, -1) - vec3(0, 0.3, 0), 1);
    fragColor = normal.xyz * vec3(1, 1, 1) * 0.5 + 0.5;
    uv = texCoord.xy;
}
