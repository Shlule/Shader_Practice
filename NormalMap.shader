Shader "Unlit/NormalMap"
{
    Properties
    {
        _Color("MainColor",Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white"{}
        _NormalMap("Normal Map", 2D) = "white"{}

    }
        SubShader
    {
        Tags
        { "RenderType" = "Opaque"
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

        uniform  half4 _Color;
        uniform sampler2D _MainTex;
        uniform float4 _MainTex_ST;
        uniform sampler2D _NormalMap;
        uniform float4 _NormalMap_ST;
        // les donne que l'on doit donner au vertex shader
        struct VertexInput {
            float4 vertex : POSITION;
            float4 texcoord : TEXCOORD0;
            float4 normal: NORMAL;
            float4 tangent: TANGENT;
        };
        // les donne que l'on doit retourene apres le vertex shader
        struct VertexOutput {
            float4 pos : SV_POSITION;
            float4 texcoord : TEXCOORD0;
            float4 normalWorld: TEXCOORD1;
            float4 tangentWorld: TEXCCORD2;
            float4 binormalWorld: TEXCOORD3;
            float4 normalTexcoord: TEXCOORD4;
        };
        // le vertex shader
        VertexOutput vert(VertexInput v)
        {
            // on initialise toute les composante de o avant de les envoyer au fragment shader.
            VertexOutput o;
            o.pos = UnityObjectToClipPos(v.vertex);
            o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
            o.texcoord.zw = 0;

            o.normalTexcoord.xy = (v.texcoord.xy * _NormalMap_ST.xy + _NormalMap_ST.zw);

            o.normalWorld = normalize(mul(v.normal, unity_WorldToObject)); // reverse the orderof multiplication to transpose the matrice
            o.tangentWorld = normalize(mul(unity_ObjectToWorld, v.tangent));
            // la binormal est la dimension perpendiculaire a la tangent et a la normal.
            o.binormalWorld = normalize(cross(o.normalWorld, o.tangentWorld) * v.tangent.w);

            return o;
        }
        float3 normalFromColor(float4 color) {
            #if defined(UNITY_NO_DXT5nm)
            return color.xyz;

            #else
            // in this case red channel is alpha
            float3 normal = float3(color.a, color.g, 0.0);
            normal.z = sqrt(1 - dot(nomal, normal));
            return normal;
            #endif

        }
        float3 WorldNormalFromNormalMap(sampler2D normalMap, float2 normalTexCoord, float3 tangentWorld, float3 binormalWorld, float3 normalWorld){
            // Color at pixel wich we read from tangent space normal map
            float4 colorAtPixel = tex2D(normalMap, normalTexCoord);

            // normal value converted from color value
            float3 normalAtPixel = normalFromColor(colorAtPixel);

            // compose TBN Matrix
            float3x3 TBNWorld = float3x3 (tangentWorld, binormalWorld, normalWorld);
            return normalize(mul(normalAtPixel, TBNWorld));
        }

            // le fragment shader
        half4 frag(VertexOutput i) : COLOR
        {
            float3 worldNormalAtPixel = WorldNormalFromNormalMap(-NormalMap, i.normalTexCoord.xy, i.tangentWorld.xyz, i.binormalWorld.xyz, i.normalWorld.xyz);
            // world NormalAtPixel return a float3 and we add 1 to make a homogenous matrix.
            return float4(worldNormalAtPixel, 1)
        }
           
            ENDCG
        }
    }
}
