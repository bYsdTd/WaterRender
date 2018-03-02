// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/Water1"
{
	Properties
	{
		_Color("Color", Color) = (1, 1, 1, 1)
		_Wave1("Wave1", Vector) = (1, 1, 1, 1)
		_Wave2("Wave2", Vector) = (1, 1, 1, 1)
		_Wave3("Wave3", Vector) = (1, 1, 1, 1)
		_Wave4("Wave4", Vector) = (1, 1, 1, 1)
	}

	SubShader
	{
		Tags { "RenderType"="Transparent" "LightMode" = "ForwardBase" "RenderQueue"="Transparent"}
		LOD 100

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float3 world_pos : TEXCOORD0;
			};
			
			float4 _Wave1;
			float4 _Wave2;
			float4 _Wave3;
			float4 _Wave4;
			float4 _Color;

			v2f vert (appdata v)
			{
				v2f o;

				float t = _Time.y;

				v.vertex.y = _Wave1.x * sin((v.vertex.x + _Wave1.y * v.vertex.z) * _Wave1.z + _Wave1.w * t);
				v.vertex.y += _Wave2.x * sin((v.vertex.x + _Wave2.y * v.vertex.z) * _Wave2.z + _Wave2.w * t);
				v.vertex.y += _Wave3.x * sin((v.vertex.x + _Wave3.y * v.vertex.z) * _Wave3.z + _Wave3.w * t);
				v.vertex.y += _Wave4.x * sin((v.vertex.x + _Wave4.y * v.vertex.z) * _Wave4.z + _Wave4.w * t);

				float dx = _Wave1.x * cos((v.vertex.x + _Wave1.y * v.vertex.z) * _Wave1.z + _Wave1.w * t) * _Wave1.z;
				dx += _Wave2.x * cos((v.vertex.x + _Wave2.y * v.vertex.z) * _Wave2.z + _Wave2.w * t) * _Wave2.z;
				dx += _Wave3.x * cos((v.vertex.x + _Wave3.y * v.vertex.z) * _Wave3.z + _Wave3.w * t) * _Wave3.z;
				dx += _Wave4.x * cos((v.vertex.x + _Wave4.y * v.vertex.z) * _Wave4.z + _Wave4.w * t) * _Wave4.z;
				
				float dz = _Wave1.x * cos((v.vertex.x + _Wave1.y * v.vertex.z) * _Wave1.z + _Wave1.w * t) * _Wave1.y * _Wave1.z;
				dz += _Wave2.x * cos((v.vertex.x + _Wave2.y * v.vertex.z) * _Wave2.z + _Wave2.w * t) * _Wave2.y * _Wave2.z;
				dz += _Wave3.x * cos((v.vertex.x + _Wave3.y * v.vertex.z) * _Wave3.z + _Wave3.w * t) * _Wave3.y * _Wave3.z;
				dz += _Wave4.x * cos((v.vertex.x + _Wave4.y * v.vertex.z) * _Wave4.z + _Wave4.w * t) * _Wave4.y * _Wave4.z;

				o.normal = normalize(float3(-dx, 1, -dz));
				o.normal = UnityObjectToWorldNormal(o.normal);

				o.world_pos = mul(unity_ObjectToWorld, v.vertex).xyz;

				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float3 light_dir = normalize(UnityWorldSpaceLightDir(i.world_pos));
				float diffuse = max(0, dot(i.normal, light_dir));

				fixed4 final_color = _Color * diffuse * fixed4(1, 1, 1, 1);


				return final_color;

				//return fixed4(i.normal, 1);
			}
			ENDCG
		}
	}
}
