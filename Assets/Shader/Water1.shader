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
		Tags { "RenderType"="Opaque" "LightMode" = "ForwardBase" }
		LOD 100

		Pass
		{
			//Blend SrcAlpha OneMinusSrcAlpha

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

			float SimpleWaveDirection(float4 vertex, float angel, out float dx, out float dz)
			{
				float2 v1 = vertex.xz;
				float2 v2;

				v2.x = cos(angel);
				v2.y = sin(angel);
				
				dx = v2.x;
				dz = v2.y;

				return v1.x * v2.x + v1.y * v2.y;
			}

			float SimpleWaveFunc(float4 vertex, float t, float4 wave_param, out float dx, out float dz)
			{
				float A = wave_param.x;
				float W = 2 * 3.1415926 / wave_param.y;
				float Fi = wave_param.z * W;

				float ddx;
				float ddz;
				float angel = wave_param.w * 3.1415926 / 180;

				float D = SimpleWaveDirection(vertex, angel, ddx, ddz);

				dx = A * cos(W * D + Fi * t) * W * ddx;
				dz = A * cos(W * D + Fi * t) * W * ddz;

				return A * sin(W * D + Fi * t);
			}

			float3 SimpleWave(float4 vertex, float t, out float3 normal)
			{
				float3 p;
				p.x = vertex.x;
				p.z = vertex.z;
				
				float dx = 0;
				float dz = 0;

				float tmp1;
				float tmp2;

				p.y = SimpleWaveFunc(vertex, t, _Wave1, tmp1, tmp2);
				dx += tmp1;
				dz += tmp2;
				p.y += SimpleWaveFunc(vertex, t, _Wave2, tmp1, tmp2);
				dx += tmp1;
				dz += tmp2;
				p.y += SimpleWaveFunc(vertex, t, _Wave3, tmp1, tmp2);
				dx += tmp1;
				dz += tmp2;
				p.y += SimpleWaveFunc(vertex, t, _Wave4, tmp1, tmp2);
				dx += tmp1;
				dz += tmp2;

				normal = normalize(float3(-dx, 1, -dz));

				return p;
			}

			v2f vert (appdata v)
			{
				v2f o;
				
				float t = _Time.y;

				float3 wave_p = SimpleWave(v.vertex, t, o.normal);
				o.normal = UnityObjectToWorldNormal(o.normal);
				o.world_pos = mul(unity_ObjectToWorld, wave_p).xyz;
				o.vertex = UnityObjectToClipPos(wave_p);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float3 light_dir = normalize(UnityWorldSpaceLightDir(i.world_pos));
				float diffuse = max(0, dot(i.normal, light_dir));

				fixed4 final_color = _Color * diffuse * fixed4(1, 1, 1, 1);


				return final_color;
			}
			ENDCG
		}
	}
}
