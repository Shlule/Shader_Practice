Shader "Unlit/RdUnlitShader"
{
    Properties// permet de faire apparaitre  les variable dans l'inspecteur unity
    {
        _Color ("Color",Color)=(1,0,0,1)
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
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };
            // set variable here
            fixed4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
                
            }
            

            fixed4 frag (v2f i) : SV_Target
            {
               return _Color;
            }
            ENDCG
        }
    }
}
