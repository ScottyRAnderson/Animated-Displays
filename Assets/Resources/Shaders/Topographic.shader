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
            #include "./Includes/Math.cginc"
            #include "./Includes/NoiseHelper.cginc"

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

            float4 _ContourColor;
            float4 _MainColor;
            float4 _CapColor;
            float _CapHeight;
            float _NoiseColor;

            float _NoiseScale;
            int _Octaves;
            float _Persistance;
            float _Lacunarity;
            float _HeightScalar;

            float evaluateNoise(float3 p)
            {
                float perlinValue = 0;
                float amplitude = 1;
                float frequency = 1;
                float contribution = 1;

                float offset = _Time.x * _AnimRate;

                // Loop through each octave and contribute
                for (int o = 0; o < _Octaves; o++)
                {
                    float3 offsetSample = p / _NoiseScale * frequency;
                    //offset += _Time.x * _AnimRate;

                    float noiseValue = (snoise(float4(offsetSample, offset)) + 0.5f) * contribution;
                    perlinValue += noiseValue * amplitude;

                    amplitude *= _Persistance;
                    frequency *= _Lacunarity;
                    contribution /= 2.0f;
                }

                perlinValue *= _HeightScalar;
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
                float perlinValue = evaluateNoise(i.worldPos);
                #if DEBUGNOISE
                return 1 - perlinValue;
                #endif

                float contourValue = calculateContours(perlinValue);

                float4 backgroundCol = _MainColor;
                if (1 - perlinValue >= _CapHeight){
                    backgroundCol = _CapColor;
                }
                else{
                    backgroundCol += lerp(0, 1, perlinValue* _NoiseColor);
                }
                float4 finalCol = lerp(backgroundCol, _ContourColor, contourValue);
                return finalCol;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}