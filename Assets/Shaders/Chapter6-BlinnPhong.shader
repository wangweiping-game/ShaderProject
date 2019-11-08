// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

//Blinn-Phong高光反射光照
Shader "Unity Shader Book/Chapter 6/Blinn Phong"
{
	Properties
	{
		//漫反射颜色
		_Diffuse("Diffuse",Color) = (1,1,1,1)

		//材质的高光反射颜色
		_Specular("Specular", Color) = (1, 1, 1, 1)

		//高光区域
		_Gloss("Gloss", Range(8.0, 256)) = 20
	}
		SubShader
	{
		Pass{
		//LightMode：指定光照模式
		Tags{ "LightMode" = "ForwardBase"}

		CGPROGRAM

		#pragma vertex vert
		#pragma fragment frag

		#include "Lighting.cginc"

		fixed4 _Diffuse;
		fixed4 _Specular;
		float _Gloss;

		struct a2v {
			float4 vertex : POSITION;
			float3 normal : NORMAL;
		};

		struct v2f {
			float4 pos : SV_POSITION;
			float3 worldNormal : TEXCOORD0;
			float3 worldPos : TEXCOORD1;
		};

		v2f vert(a2v v) {
			v2f o;

			//模型空间的顶点位置转换到剪裁空间中
			o.pos = UnityObjectToClipPos(v.vertex);

			//模型空间的法线转换到世界空间中
			o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);

			//模型空间的顶点位置转换到世界空间中
			o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

			return o;
		}

		fixed4 frag(v2f i) :SV_Target{
			//环境光
			fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

		// normalize 归一化 
		fixed3 worldNormal = normalize(i.worldNormal);

		//内置变量：_WorldSpaceLightPos0 获得光源方向
		fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

		//内置变量：_LightColor0  获得光源的颜色和强度信息
		//saturate 函数：可以把参数截取到[0,1]的范围内
		fixed diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));

		//反射方向
		fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));

		//视角方向 = 世界空间的摄像机位置 - 世界空间的顶点位置
		fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

		fixed3 halfDir = normalize(worldLightDir + viewDir);

		fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0,dot(worldNormal, halfDir)), _Gloss);

		//最终光照结果 = 环境光 + 漫反射 + 高光反射
		fixed3 color = ambient + diffuse + specular;

		return fixed4(color,1.0);
	}

	ENDCG
}
	}
		Fallback "Specular"
}
