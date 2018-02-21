// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "ShaderPack/Hologram" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_Rim("RimFactor", Range(0,1)) = 0.5
		_NoiseTex("NoiseTexture", 2D) = "white" {}
		_SourceHeight("SourceHeight",Float) = 0
	}
	SubShader {
		Tags { 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
		} 
		Blend SrcAlpha OneMinusSrcAlpha


		Pass{
			ZWrite Off
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"


			sampler2D _NoiseTex;
			fixed4 _Color;
			float _Rim;
			float _SourceHeight;

			struct v2f{
				float4 position : SV_POSITION;
				float3 worldPos : POSITION2;
				float3 normal : NORMAL;
				float3 viewDir : POSITION3;
				float3 uv : TEXCOORD1;
				float3 screenPos : POSITION4;
			};

			v2f vert(appdata_base IN){
				v2f o;
				o.worldPos = mul(unity_ObjectToWorld, IN.vertex).xyz;
				o.position = UnityObjectToClipPos(IN.vertex);
				o.normal = UnityObjectToWorldNormal(IN.normal);
				o.viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, IN.vertex).xyz);
				o.uv = IN.texcoord;
				o.screenPos = ComputeScreenPos(o.position);
				return o;
			}

			fixed4 frag(v2f IN) : SV_Target{
				
				//IN.uv.x += _Time.x;
				fixed2 texuv = IN.uv;
				texuv.x += _Time.y + IN.worldPos.y * 20;
				half2 uvs = IN.screenPos.xy/10;
				//uvs.y *= 200 * _Time.y;

				fixed source = _SourceHeight / IN.worldPos.y * 3;
				fixed smoke = tex2D(_NoiseTex, uvs) * source;
				fixed tex =  tex2D(_NoiseTex, texuv);

				float rim = 1 - (dot(IN.viewDir, IN.normal) / _Rim);
				float down = dot(IN.normal,float3(0,-1,0));
				float outerrim = pow(rim,1.0f) + down* 0.5f;
				fixed4 col = (_Color + outerrim + smoke) * tex * 2;



				half2 noiseuv = half2(_Time.x,_Time.x);
				col.a *= (tex2D(_NoiseTex, noiseuv)+0.5f) * tex;

				return col;
			}


			ENDCG
		}

	}

}
