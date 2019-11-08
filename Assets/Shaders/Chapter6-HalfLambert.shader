// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

//半兰伯特光照
Shader "Unity Shader Book/Chapter 6/Half Lambert"
{
	Properties{
		_Diffuse("Diffuse", Color) = (1,1,1,1)
	}

	SubShader
	{
		Pass
		{
		//指定光照模式
		Tags { "LightMode" = "ForwardBase"}

		CGPROGRAM

		#pragma vertex vert
		#pragma fragment frag

		//引用内置文件
		#include "Lighting.cginc"

		fixed4 _Diffuse;

		struct a2v {
			float4 vertex : POSITION;
			float3 normal : NORMAL;
		};

		struct v2f {
			float4 pos : SV_POSITION;
			float3 worldNormal : TEXCOORD0;
		};
		v2f vert(a2v v) {
			v2f o;

			//顶点坐标从模型空间转换到世界空间
			o.pos = UnityObjectToClipPos(v.vertex);

			//法线转换到世界空间中
			o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);

			return o;
		}

		fixed4 frag(v2f i) :SV_Target{

			//环境光
			fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

		//normalize 归一化 
		fixed3 worldNormal = normalize(i.worldNormal);

		//内置变量：_WorldSpaceLightPos0 获得光源方向
		fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);


		fixed halfLambert = dot(worldNormal, worldLightDir) * 0.5 + 0.5;

		//内置变量：_LightColor0  获得光源的颜色和强度信息
		fixed diffuse = _LightColor0.rgb * _Diffuse.rgb * halfLambert;

		//最终光照结果 = 环境光+漫反射
		fixed3 color = ambient + diffuse;

		return fixed4(color,1.0);
	}

	ENDCG
}

	}
		FallBack "Diffuse"
}