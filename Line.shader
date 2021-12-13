Shader "Unlit/Line"
{
    Properties
    {
        _Color("MainColor",Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white"{}
        _Start("Start", float) = 0.4
        _Width("width",float)=0.6

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
            uniform float _Start;
            uniform float _Width;
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
            float DrawLine(float2 uv, float start, float end){
                start =_Start;
                end = _Width;
                if(uv.x >start && uv.x < end){
                    return 1;
                }
                return 0;
            }

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
                float4 color = tex2D(_MainTex,i.texcoord)* _Color;
                color.a =DrawLine(i.texcoord.xy,0.4,0.6);
                return color;
            }
           
            ENDCG
        }
    }
}
