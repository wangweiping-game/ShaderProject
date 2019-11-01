// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shader Book/Chapter 5/SImple Shader"
{
	Properties{
		//属性:_Color  属性名称:"Color Tint" 属性类型:Color  初始值:(1.0...)
		_Color("Color Tint", Color) = (1.0,1.0,1.0,1.0)
	}
		SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert //顶点着色器函数  
			#pragma fragment frag //片元着色器函数

			fixed4 _Color;//要与Properties中的属性名称一直
			struct a2v {
				float4 vertex : POSITION; //模型的顶点坐标
				float3 normal : NORMAL; //顶点法线
				float4 texcoord : TEXCOORD0; //顶点的第一组纹理坐标
			};
			struct v2f{
				float4 pos : SV_POSITION; //剪裁空间上的顶点坐标
				fixed3 color : COLOR0; //顶点颜色
			};
			v2f vert(a2v v ) 
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex); //顶点坐标从模型空间转换到剪裁空间
				o.color = v.normal * 0.5 + fixed3(0.5,0.5,0.5);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed3 c = i.color;
				c *= _Color.rgb;
				return fixed4(c,1.0);
            }
            ENDCG
        }
    }
}
