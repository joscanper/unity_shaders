
Shader "ShaderPack/ConeOfSight" {
	Properties {
		_Color("Color",Color) = (1,1,1,1)
		_SightAngle("SightAngle",Float) = 0.5
		//_CurrentAngle("CurrentAngle",Range(0,360)) = 0
		_FarHardness("FarHardness",Range(10,0)) = 5
		_RangeHardness("RangeHardness",Range(0,100)) = 5
		_RangeStep("RangeStep",Range(0,1)) = 0.7
	}

	SubShader{
	 	Tags { 
	 		"Queue"="Transparent"
	 		"RenderType"="Transparent" 
	 	} 
	 	Blend  SrcAlpha OneMinusSrcAlpha
		Pass{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct v2f{
				float4 position : SV_POSITION;
				float4 localpos : POSITION1;
			};

			half4 _Color;
			half _SightAngle;
			//half _CurrentAngle;
			half _FarHardness;
			half _RangeHardness;
			half _RangeStep;

			uniform int _BufferSize = 256;
			uniform float _SightDepthBuffer[100];

			//Vertex
			v2f vert(appdata_base IN){
				v2f o;
				o.position = mul(UNITY_MATRIX_MVP, IN.vertex);
				o.localpos = IN.vertex;
				return o;
			}

			//Fragment
			fixed4 frag(v2f IN) : SV_Target{
				const float PI = 3.14159;

				// -- Radial
				half distcenter = 1-sqrt(IN.localpos.x*IN.localpos.x + IN.localpos.y*IN.localpos.y)*2;
				half4 col = clamp(lerp(half4(1,1,1,0),half4(1,1,1,1),distcenter),0,1);
				col.a = pow(col.a,_FarHardness);

				// --- View triangle
				//half radAngle = _CurrentAngle * PI / 180;
				half2 viewerdir = half2(1,0);
				half2 fragmentdir = normalize(IN.localpos.xy);
				half viewDotPos = clamp(dot(viewerdir, fragmentdir),0,1);
				half sightAngleRads = _SightAngle/2 * PI / 180;
				half sightVal = cos(sightAngleRads);

				col.a *= pow(viewDotPos/sightVal,_RangeHardness);
				if (viewDotPos<sightVal){
					col.a *= _RangeStep;
				}else{
					// --- Depth
					float fragmentangle = asin(fragmentdir.y)+sightAngleRads;
					float fragmentval = 1.0f-(fragmentangle)/(sightAngleRads*2);

					int index = _BufferSize- fragmentval * _BufferSize;
					if (_SightDepthBuffer[index]>0 && (1-distcenter)>_SightDepthBuffer[index]){
						col *= 0.7f;
						col.a *= 0.7f;
					}
					
				}


				//col.a /= 2;
				//if (col.a < 1 && col.a > 0)
				//	col.a = pow(col.a,_RangeHardness);

				//if(viewDotPos > 0.99999f)
					//col = half4(1,0,0,1);

				return col * _Color;
			}

			ENDCG
		}
	}

}

