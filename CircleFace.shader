Shader "Unlit/CircleFace"
{
    Properties
    {
        _Color("MainColor",Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white"{}
        _Feather("Feather",float) = 0.4
        _Radius("Radius",float)=0.4
        _Center("Center",float)=0.4
        

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
            uniform float _Radius;
            uniform float _Center;
            uniform float _Feather;
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
            float DrawCircle (float2 uv, float2 center, float radius, float feather){
                float circle = pow((uv.y-center.y),2 )+ pow((uv.x-center.x),2);
                float radiusSquare = pow(radius,2);
                if(circle < radiusSquare){
                    return smoothstep(radiusSquare,radiusSquare-feather,circle);
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
                float4 color = tex2D(_MainTex,i.texcoord)*_Color;
                color.a = DrawCircle(i.texcoord.xy,_Center,_Radius,_Feather);
                return color;
            }
           
            ENDCG
        }
    }
}
