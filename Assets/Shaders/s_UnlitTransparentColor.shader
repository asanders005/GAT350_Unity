Shader "GAT350/UnlitTransparentColor"
{
    Properties
    {
		[Header(Shader Info)][Space(20)]
		[Toggle] _Active ("Active", float) = 1

        _Color ("Color", Color) = (1, 1, 1, 1)
		_Transparency ("Transparency", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 100

		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite Off

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
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            fixed4 _Color;

			float _Transparency;
			float _Active;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				UNITY_APPLY_FOG(i.fogCoord, _Color);
                return fixed4(_Color.rgb, _Color.a  * (_Active) ? _Transparency : 1);
            }
            ENDCG
        }
    }
}
