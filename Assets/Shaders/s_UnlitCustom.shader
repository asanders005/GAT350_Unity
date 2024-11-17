Shader "GAT350/UnlitCustom"
{
    Properties
    {
		[Header(Color Palette)][Space(20)]
        _ColorA("Color a", Color) = (1, 1, 1, 1)
        _ColorB("Color b", Color) = (1, 1, 1, 1)
        _ColorC("Color c", Color) = (1, 1, 1, 1)
        _ColorD("Color d", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float3 objectPos : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

			fixed4 _ColorA;
			fixed4 _ColorB;
			fixed4 _ColorC;
			fixed4 _ColorD;

			// Palette variation
			// https://iquilezles.org/articles/palettes/
			float3 palette(float t)
			{
				float3 a = float3(_ColorA.rgb);
				float3 b = float3(_ColorB.rgb);
				float3 c = float3(_ColorC.rgb);
				float3 d = float3(_ColorD.rgb);

				float twoPi = 6.24318;

				return a + (b * cos(twoPi * (c * t + d)));
			}

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.objectPos = v.vertex.xyz;
                //UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				float3 uv = i.objectPos;
				float3 uv0 = uv;
                float3 color = (0.0, 0.0, 0.0);
                
				for (float f = 0.0; f < 4.0; f++)
				{
					uv = frac(uv * 1.5) - 0.5;

					float d = length(uv) * exp(-length(uv0));

					float3 col = palette(length(uv0) + f * 0.4 + _Time.y * 0.4);

					d = sin(d * 8.0 + _Time.y) / 8.0;
					d = abs(d);

					d = pow(0.01 / d, 1.2);

					color += col * d;
				}

                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, color);
                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
}