Shader "Unlit/Start"
{
    Properties
    {
        _Color("MainColor",Color) = (1,1,1,1)
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

            uniform  half4 _Color;

            struct VertexInput{
                float4 vertex : POSITION;
            };

            struct VertexOutput{
                float4 pos : SV_POSITION;
            };

            VertexOutput vert(VertexInput v)
            {
                VertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            half4 frag( VertexOutput i) :COLOR 
            {
                return _Color;
            }
           
            ENDCG
        }
    }
}
