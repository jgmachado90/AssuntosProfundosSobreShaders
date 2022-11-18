Shader "Unlit/BlendingSample"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainColor("Color", Color) = (1,1,1,1)
        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcBlend("Source Factor", Float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstBlend("Destination Factor", Float) = 1
        [Enum(UnityEngine.Rendering.BlendOp)]
        _BlendOp("BlendOp", float) = 1
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        //ZWrite Off
        Blend [_SrcBlend] [_DstBlend]
        BlendOp [_BlendOp]
 

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
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _MainColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //fixed4 col = tex2D(_MainTex, i.uv);
                return _MainColor;
            }
            ENDCG
        }
    }
}
