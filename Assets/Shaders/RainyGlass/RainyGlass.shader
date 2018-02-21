// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "ShaderPack/Test" {
	Properties {
		_Opacity ("Opacity", Range(0.1,1)) = 0.5
		_BumpFactor ("BumpFactor", Range(0,1)) = 0.5
		_MainTex ("Texture", 2D) = "white" {}
		_BumpTex ("BumpTexture", 2D) = "white" {}
		_DropsTex ("DropsTexture", 2D) = "white" {}
	}

	SubShader{
	 	Tags { "Queue"="Transparent" "RenderType"="Transparent" } Blend SrcAlpha OneMinusSrcAlpha
		GrabPass{"_GrabTex"}
		Pass{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct v2f{
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 uvgrab : TEXCOORD1;
			};

			float _Opacity;
			float _BumpFactor;

			sampler2D _MainTex;
			sampler2D _GrabTex;
			sampler2D _BumpTex;
			sampler2D _DropsTex;

			//Vertex
			v2f vert(appdata_base IN){
				v2f OUT;
				OUT.position = UnityObjectToClipPos(IN.vertex);
				OUT.uv = IN.texcoord;
				OUT.uvgrab = ComputeGrabScreenPos(OUT.position);

				return OUT;
			}

			half4 blur_grab(float4 proj, float blur){
				half4 col = tex2Dproj(_GrabTex, proj );
				col+= tex2Dproj(_GrabTex, proj + float4(0, -blur, 0,0));
				col+= tex2Dproj(_GrabTex, proj + float4(0, blur, 0,0));
				col+= tex2Dproj(_GrabTex, proj + float4(-blur, 0, 0,0));
				col+= tex2Dproj(_GrabTex, proj + float4(blur,0, 0,0));

				col+= tex2Dproj(_GrabTex, proj + float4(blur,blur, 0,0));
				col+= tex2Dproj(_GrabTex, proj + float4(blur,-blur, 0,0));
				col+= tex2Dproj(_GrabTex, proj + float4(-blur,blur, 0,0));
				col+= tex2Dproj(_GrabTex, proj + float4(-blur,-blur, 0,0));

				return col/9;
			}

			//Fragment
			fixed4 frag(v2f IN) : SV_Target{
				//half4 bump = tex2D(_BumpTex, IN.uv) ;
				half4 col = tex2D(_MainTex, IN.uv);
				half4 bump = tex2D(_BumpTex, IN.uv);
				half3 distortion = UnpackNormal(bump);


				IN.uv.y += _Time.y *0.5 ;
				IN.uv.x += sin(IN.uv.y * IN.position.y / 1000000) * 0.01;
				half4 drop = tex2D(_DropsTex, IN.uv);
				float threshold =  abs(drop.a - abs(sin(_Time.y*0.5)));
				if (drop.a>0.1){
					//col = half4(1,0,0,1);
					IN.uvgrab.y += distortion.g * _BumpFactor * 0.01;
					IN.uvgrab.x += distortion.g * _BumpFactor * 0.01;
				}else{
					IN.uvgrab.y += distortion.g * _BumpFactor;
					IN.uvgrab.x += distortion.g * _BumpFactor * 0.2;
				}

				half4 grab = blur_grab(IN.uvgrab, 0.01);

				half4 l = lerp(grab, col, _Opacity);
				col.rgb = l * grab.rgb*1.5;

				return col;
			}

			ENDCG
		}
	}

}

