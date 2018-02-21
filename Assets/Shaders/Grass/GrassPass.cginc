// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

#include "UnityCG.cginc"

sampler2D _MainTex;
fixed4 _MainTex_ST;
sampler2D _BaseTex;
fixed4 _BaseTex_ST;
sampler2D _DesignTex;

fixed4 _ColorEnd;
fixed4 _ColorGround;
fixed4 _GroundTint;
float4 _GrassDirection;
float _GrassStepH;
float4 _DesignOffset;

struct v2f{
	float4 position: SV_POSITION;
	float2 uv1 : TEXCOORD1;
	float2 uv2 : TEXCOORD2;
	float2 uvWorld : TEXCOORD3;
	float3 worldPos : TEXCOORD4;
	float3 normal : TEXCOORD5;
	float height : FLOAT;
};



v2f vert(appdata_base IN){
	v2f o;
	o.height = GRASS_STEP*_GrassStepH/1000000;
	IN.vertex.xyz += o.height * IN.normal;
	IN.vertex.xz += o.height * fixed2(sin(o.height*500)*50 + _GrassDirection.x, _GrassDirection.y) ;
	o.position = UnityObjectToClipPos(IN.vertex);
	o.worldPos =  mul(unity_ObjectToWorld, IN.vertex);
	 o.normal = UnityObjectToWorldNormal(IN.normal);
	//o.uv = IN.texcoord * 55;

	o.uv1 = TRANSFORM_TEX(IN.texcoord, _MainTex);
	o.uv2 = TRANSFORM_TEX(IN.texcoord, _BaseTex);
	o.uvWorld = float2(o.worldPos.z/_DesignOffset.x+_DesignOffset.z, o.worldPos.x/_DesignOffset.y+_DesignOffset.w);
	return o;
}

fixed4 frag(v2f IN) : SV_Target{
	half3 viewDir = UnityWorldSpaceViewDir(IN.worldPos);
	float ndot = clamp(1-dot(IN.normal, normalize(viewDir)),0,1);
	float ndot8 = pow(ndot, 8);

	fixed4 designcol = tex2D(_DesignTex, IN.uvWorld);

	if (IN.height == 0)
		return tex2D(_BaseTex, IN.uv2) * _GroundTint + ndot8 * 0.65f;

	fixed4 mask = tex2D(_MainTex, IN.uv1);
	clip(mask.a/ndot8*ndot8 - pow(IN.height,0.07));

	fixed4 retcol = clamp(lerp(_ColorGround, _ColorEnd + designcol, GRASS_STEP/15.0f + ndot8*2), 0, 1);	
	retcol.a = 1-ndot8*ndot8;
	return retcol;
	
}
