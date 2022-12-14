Shader "Unlit/UnlitWorld1"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Example color", Color) = (.25, .5, .5, 1)
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Opaque"
           /*"LightMode" = "ForwardBase"*/
            "PassFlags" = "OnlyDirectional"
        }
        LOD 100
       
        Stencil{
            ref 1
            Comp NotEqual
        }

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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 worldNormal : NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                UNITY_TRANSFER_FOG(o,o.vertex);
                
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                /*// sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;*/
                float3 normal = normalize(i.worldNormal);
                float NdotL = dot(_WorldSpaceLightPos0, normal);
                return _Color * NdotL;
            }
            ENDCG
        }
    }
}
