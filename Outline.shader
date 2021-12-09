Shader "Unlit/Outline"
{
    Properties
    {
        _Color("MainColor",Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white"{}
        _Outline("Outline" , float) = 0.1
        _OutlineColor("OutlineColor", Color) = (1,1,1,1)


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
            cull front
            Zwrite off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // set variable 

            uniform half _Outline;
            uniform half4 _OutlineColor;

            struct vertexInput {
                float4 vertex: POSITION;
            };
            struct VertexOutput{
                float4 pos: SV_POSITION;
            };

            float4 Outline (float4 pos, float outline){
                // creation de la matrice "scale" homogene toute les valeur sont a 0.0.
                float4x4 scale =0.0;
                // initialisation des valeur diagonal de la matrice.
                scale[0][0]=1.0 + outline;
                scale[1][1]=1.0 + outline;
                scale[2][2]=1.0 + outline;
                scale[3][3]= 1.0;
                return mul(scale, pos); 

            }

            VertexOutput vert(vertexInput v){
                VertexOutput o;
                o.pos = UnityObjectToClipPos(Outline(v.vertex, _Outline));
                return o;

            }
            half4 frag (VertexOutput i): COLOR 
            {
                return _OutlineColor;
            }

            ENDCG
        }
        // draw Outline behind the object
    }
}
