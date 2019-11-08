// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

//逐顶点漫反射光照
Shader "Unity Shader Book/Chapter 6/Diffuse Vertex-Level"
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
				fixed3 color : COLOR;
			};

			v2f vert(a2v v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				//环境光
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				//法线转换到世界空间中 normalize 归一化 
				fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));

				//内置变量：_WorldSpaceLightPos0 获得光源方向
				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

				//内置变量：_LightColor0  获得光源的颜色和强度信息
				//saturate 函数：可以把参数截取到[0,1]的范围内
				fixed diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));

				//最终光照结果 = 环境光+漫反射
				o.color = ambient + diffuse;

				return o;
			}

			fixed4 frag(v2f i) :SV_Target{
				return fixed4(i.color,1.0);
			}
		ENDCG
		}
		
	}
	FallBack "Diffuse"
}