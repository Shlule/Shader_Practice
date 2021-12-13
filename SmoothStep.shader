Shader "Unlit/Texture"
{
    Properties
    {
        _Color("MainColor",Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white"{}
        _Lower("Lower", float)=0.5
        _Higher("Higher", float)=0.5

    }
    SubShader
    {
        Tags 
        { "RenderType"="Opaque"
        "RenderType" = "Transparent"
        "IgnoreProjector" = "True"
        }

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // set variable here
            uniform float _Lower;
            uniform float _Higher;
            uniform  half4 _Color;
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;

            struct VertexInput{
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0;
            };

            struct VertexOutput{
                float4 pos : SV_POSITION;
                float4 texcoord : TEXCOORD0;
            };

            VertexOutput vert(VertexInput v)
            {
                VertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.texcoord.xy =( v.texcoord.xy * _MainTex_ST.xy +_MainTex_ST.zw);
                o.texcoord.zw =0;
                return o;
            }

            half4 frag(VertexOutput i) : COLOR 
            {
                float4 color= tex2D(_MainTex,i.texcoord)*_Color;
                color.a = smoothstep(_Lower,_Higher,i.texcoord.x);
                return color;
            }
           
            ENDCG
        }
    }
}
