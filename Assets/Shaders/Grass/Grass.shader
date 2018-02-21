Shader "ShaderPack/Grass" {
	Properties {
		_ColorEnd ("Color End", Color) = (1,1,1,1)
		_ColorGround ("Color Ground", Color) = (0,0,0,1)
		_GroundTint ("Ground Tint", Color) = (0,0,0,1)
		_GrassDirection("Grass Direction", Vector) = (0,0,0,0)
		_GrassStepH("Grass Height",float) = 0.0002
		_MainTex ("Mask", 2D) = "white" {}
		_BaseTex ("Base", 2D) = "white" {}
		_DesignTex ("Design", 2D) = "white" {}
		_DesignOffset("Design Offset", Vector) = (0,0,0,0)
	}
	SubShader {
		Tags { "Queue"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		
		Pass{
			CGPROGRAM
			//#pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
			#pragma vertex vert
			#pragma fragment frag
			#define GRASS_STEP 0
			#include "GrassPass.cginc"
			ENDCG
		}

		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#define GRASS_STEP 1
			
			#include "GrassPass.cginc"
			ENDCG
		}


		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#define GRASS_STEP 2
			#include "GrassPass.cginc"
			ENDCG
		}

		
		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#define GRASS_STEP 3
			#include "GrassPass.cginc"
			ENDCG
		}

		
		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#define GRASS_STEP 4
			#include "GrassPass.cginc"
			ENDCG
		}

		
		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#define GRASS_STEP 5
			#include "GrassPass.cginc"
			ENDCG
		}

		
		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#define GRASS_STEP 6
			#include "GrassPass.cginc"
			ENDCG
		}

		
		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#define GRASS_STEP 7
			#include "GrassPass.cginc"
			ENDCG
		}

		
		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#define GRASS_STEP 8
			#include "GrassPass.cginc"
			ENDCG
		}

		
		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#define GRASS_STEP 9
			#include "GrassPass.cginc"
			ENDCG
		}

		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#define GRASS_STEP 10
			#include "GrassPass.cginc"
			ENDCG
		}

		
		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#define GRASS_STEP 11
			#include "GrassPass.cginc"
			ENDCG
		}

		
		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#define GRASS_STEP 12
			#include "GrassPass.cginc"
			ENDCG
		}

		
		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#define GRASS_STEP 13
			#include "GrassPass.cginc"
			ENDCG
		}

		
		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#define GRASS_STEP 14
			#include "GrassPass.cginc"
			ENDCG
		}


	}
	FallBack "Diffuse"
}
