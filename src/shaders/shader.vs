#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aColor;

// out vec3 ourColor;
// uniform float xOffset;
out vec3 ourPosition;


void main()
{
    gl_Position = vec4(aPos, 1.0);
    //gl_Position = vec4(aPos.x, -aPos.y, aPos.z, 1.0);
    // ourColor = aColor;
    ourPosition = aPos;

}

/*
   Q3: 为什么在三角形的左下角是黑的？
   将顶点位置作为颜色设置，在左下点的坐标是(x, y, 0.0f),其中 x，y均为负数，在RGB中表示黑色（0.0f, 0.0f, 0.0f）。

*/
