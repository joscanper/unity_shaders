// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "ShaderPack/Hologram" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_Rim("RimFactor", Range(0,1)) = 0.5
		_MainTex("MainTexture", 2D) = "white" {}
	}
	SubShader {
		Tags { 
			"Queue"="Transparent" 
			"RenderType"="Transparent" 
		} 
		Blend SrcColor DstAlpha
		Pass{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			fixed4 _Color;
			float _Rim;

			struct v2f{
				float4 position : SV_POSITION;
				float3 worldPos : POSITION2;
				float3 normal : NORMAL;
				float3 viewDir : POSITION3;
				float3 uv : TEXCOORD1;
			};

			v2f vert(appdata_base IN){
				v2f o;
				o.worldPos = mul(unity_ObjectToWorld, IN.vertex).xyz;
				o.position = mul(UNITY_MATRIX_MVP, IN.vertex);
				o.normal = UnityObjectToWorldNormal(IN.normal);
				o.viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, IN.vertex).xyz);
				o.uv = IN.texcoord;

				return o;
			}

			fixed4 frag(v2f IN) : SV_Target{
				
				IN.uv.x += _Time.y + IN.worldPos.y*10;
				float tex = tex2D(_MainTex, IN.uv);
				float rim = 1 - (dot(IN.viewDir, IN.normal) / _Rim) * _Color;
				float down = dot(IN.normal,float3(0,-1,0));
				float outerrim = pow(rim,4.0f) * _Rim + (0.15f/IN.worldPos.y) + down*0.3f;
				fixed4 col = _Color * rim * tex;
				col += outerrim;
				col.a = rim;
				return col;
			}


			ENDCG
		}

	}

}
