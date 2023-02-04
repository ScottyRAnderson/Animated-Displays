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
            #include "UnityCG.cginc"
            #include "Packages/jp.keijiro.noiseshader/Shader/ClassicNoise2D.hlsl"

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

            float _AnimRate;

            float _NoiseScale;
            int _Octaves;
            float _Persistance;
            float _Lacunarity;
            float _HeightScalar;

            float evaluateNoise(float2 p)
            {
                float perlinValue = 0;
                float amplitude = 1;
                float frequency = 1;
                float contribution = 1;

                // Loop through each octave and contribute
                for (int o = 0; o < _Octaves; o++)
                {
                    float2 offsetSample = p / _NoiseScale * frequency;
                    offsetSample += _Time.x * _AnimRate;

                    float noiseValue = (ClassicNoise(offsetSample) + 0.5f) * contribution;
                    perlinValue += noiseValue * amplitude;

                    amplitude *= _Persistance;
                    frequency *= _Lacunarity;
                    contribution /= 2.0f;
                }

                perlinValue *= _HeightScalar;
                return perlinValue;
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
                float perlinValue = evaluateNoise(i.uv);
                perlinValue = evaluateNoise(i.uv * perlinValue);
                return perlinValue;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}