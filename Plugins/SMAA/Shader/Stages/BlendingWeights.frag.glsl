/**
 * 
 * RenderPipeline
 * 
 * Copyright (c) 2014-2015 tobspr <tobias.springer1@gmail.com>
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#version 400

#pragma include "Includes/Configuration.inc.glsl"
#pragma include "../SMAAWrap.inc.glsl"

uniform sampler2D EdgeTex;
uniform sampler2D AreaTex;
uniform sampler2D SearchTex;

uniform int JitterIndex;

out vec4 result;

void main() {

    vec2 texcoord = get_texcoord();

    // "Vertex shader"
    vec4 offset[3];
    vec2 pixcoord;
    SMAABlendingWeightCalculationVS(texcoord, pixcoord, offset);

    #if GET_SETTING(SMAA, use_reprojection)
        vec4 subsampleIndices = JitterIndex == 0 ? vec4(1, 1, 1, 0) : vec4(2, 2, 2, 0);
    #else
        vec4 subsampleIndices = vec4(0);
    #endif

    if (textureLod(EdgeTex, texcoord, 0).w < 0.5) discard;

    // Actual Fragment shader
    result = SMAABlendingWeightCalculationPS(texcoord, pixcoord, offset, EdgeTex, AreaTex, SearchTex, subsampleIndices);
   
}