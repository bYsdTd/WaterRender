// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/Water2"
{
	Properties
	{
		_Color("Color", Color) = (1, 1, 1, 1)
		_Wave1("Wave1", Vector) = (1, 1, 1, 1)
		_Wave2("Wave2", Vector) = (1, 1, 1, 1)
		_Wave3("Wave3", Vector) = (1, 1, 1, 1)
		_Wave4("Wave4", Vector) = (1, 1, 1, 1)
		_GerstnerQ("GerstnerQ", Vector) = (1, 1, 1, 1)
	}

	SubShader
	{
		Tags { "RenderType"="Opaque" "LightMode" = "ForwardBase" }
		LOD 100

		Pass
		{
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
			float4 _GerstnerQ;

			float WaveDirection(float4 vertex, float angel, out float dx, out float dz)
			{
				float2 v1 = vertex.xz;
				float2 v2;

				v2.x = cos(angel);
				v2.y = sin(angel);
				
				dx = v2.x;
				dz = v2.y;

				return v1.x * v2.x + v1.y * v2.y;
			}

			float3 GestnerWaveFunc(float4 vertex, float t, float4 wave_param, float Q, out float3 d)
			{
				float3 p;

				float A = wave_param.x;
				float W = 2 * 3.1415926 / wave_param.y;
				float Fi = wave_param.z * W;

				float ddx;
				float ddz;
				float angel = wave_param.w * 3.1415926 / 180;

				float D = WaveDirection(vertex, angel, ddx, ddz);

				p.x = Q * A * ddx * cos(W * D + Fi * t);
				p.z = Q * A * ddz * cos(W * D + Fi * t);
				p.y = A * sin(W * D + Fi * t);

				d.x = -ddx * W * A * cos(W * D + Fi * t);
				d.z = -ddz * W * A * cos(W * D + Fi * t);
				d.y = -Q * W * A * sin(W * D + Fi * t);
				return p;
			}

			float3 GestnerWave(float4 vertex, float t, out float3 normal)
			{
				float3 p;
				p = vertex.xyz;
				
				float3 d = float3(0,0,0);
				float3 tmp;

				p += GestnerWaveFunc(vertex, t, _Wave1, _GerstnerQ.x, tmp);
				d += tmp;
				p += GestnerWaveFunc(vertex, t, _Wave2, _GerstnerQ.y, tmp);
				d += tmp;
				p += GestnerWaveFunc(vertex, t, _Wave3, _GerstnerQ.z, tmp);
				d += tmp;
				p += GestnerWaveFunc(vertex, t, _Wave4, _GerstnerQ.w, tmp);
				d += tmp;

				d.y += 1;

				normal = normalize(d);

				return p;
			}
			
			v2f vert (appdata v)
			{
				v2f o;
				
				float t = _Time.y;

				float3 wave_p = GestnerWave(v.vertex, t, o.normal);
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
