Shader "Custom/Topographic"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature DEBUGNOISE

            #include "UnityCG.cginc"
            #include "Packages/jp.keijiro.noiseshader/Shader/ClassicNoise2D.hlsl"
            #include "Packages/jp.keijiro.noiseshader/Shader/SimplexNoise2D.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldPos : TEXCOORD1;
            };

            int _NumContours;
            float _ContourWidth;
            float _ContourSpacing;
            float _AnimRate;

            float _HeightBias;
            float _NoiseScale;
            int _Octaves;
            float _Persistance;
            float _Lacunarity;
            float _HeightScalar;

            float bias(float x, float bias)
            {
                // Adjust input to make control feel more linear
                float k = pow(1 - bias, 3);
                // Equation based on: shadertoy.com/view/Xd2yRd
                return (x * k) / (x * k - x + 1);
            }

            float evaluateNoise(float2 p, float offset)
            {
                float perlinValue = 0;
                float amplitude = 1;
                float frequency = 1;
                float contribution = 1;

                p += offset * _AnimRate;

                // Loop through each octave and contribute
                for (int o = 0; o < _Octaves; o++)
                {
                    float2 offsetSample = p / _NoiseScale * frequency;
                    //offsetSample += _Time.x * _AnimRate;

                    float noiseValue = (SimplexNoise(offsetSample) + 0.5f) * contribution;
                    perlinValue += noiseValue * amplitude;

                    amplitude *= _Persistance;
                    frequency *= _Lacunarity;
                    contribution /= 2.0f;
                }

                perlinValue *= _HeightScalar;
                perlinValue = bias(perlinValue, _HeightBias);
                return perlinValue;
            }

            float calculateContours(float value)
            {
                float contour = 0;

                // Height of our first contour line
                float baseHeight = 1 - ((_NumContours * _ContourWidth) + (_NumContours * _ContourSpacing));
                float height = baseHeight;

                for (int c = 0; c < _NumContours; c++)
                {
                    // Determine if value lies within valid contour zones
                    float min = height;
                    float max = height + _ContourWidth;

                    if (value > min && value < max){
                        contour = 1;
                    }

                    height += _ContourWidth + _ContourSpacing;
                }

                return contour;
            }

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float offset = evaluateNoise(i.uv, _Time.x);

                float perlinValue = evaluateNoise(i.uv, offset);
                #if DEBUGNOISE
                return perlinValue;
                #endif

                float contourValue = calculateContours(perlinValue);
                return contourValue;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}