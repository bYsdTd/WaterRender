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
			float4 _GerstnerQ;

			// float WaveDirection(float x, float y, float param)
			// {
			// 	return x + param * y;
			// }

			// float3 GetWave(float x, float z)
			// {
			// 	float3 p;
			// 	p.x = x;
			// 	p.z = z;
			// 	float t = _Time.y;
			// 	p.y = _Wave1.x * sin(WaveDirection(x, z, _Wave1.y) * _Wave1.z + _Wave1.w * t);
			// 	p.y += _Wave2.x * sin(WaveDirection(x, z, _Wave2.y) * _Wave2.z + _Wave2.w * t);
			// 	p.y += _Wave3.x * sin(WaveDirection(x, z, _Wave3.y) * _Wave3.z + _Wave3.w * t);
			// 	p.y += _Wave4.x * sin(WaveDirection(x, z, _Wave4.y) * _Wave4.z + _Wave4.w * t);

			// 	return p;
			// }

			// float3 GetWaveNormal(float x, float z)
			// {
			// 	float t = _Time.y;

			// 	float dx = _Wave1.x * cos(WaveDirection(x, z, _Wave1.y) * _Wave1.z + _Wave1.w * t) * _Wave1.z;
			// 	dx += _Wave2.x * cos(WaveDirection(x, z, _Wave2.y) * _Wave2.z + _Wave2.w * t) * _Wave2.z;
			// 	dx += _Wave3.x * cos(WaveDirection(x, z, _Wave3.y) * _Wave3.z + _Wave3.w * t) * _Wave3.z;
			// 	dx += _Wave4.x * cos(WaveDirection(x, z, _Wave4.y) * _Wave4.z + _Wave4.w * t) * _Wave4.z;
				
			// 	float dz = _Wave1.x * cos(WaveDirection(x, z, _Wave1.y) * _Wave1.z + _Wave1.w * t) * _Wave1.y * _Wave1.z;
			// 	dz += _Wave2.x * cos(WaveDirection(x, z, _Wave2.y) * _Wave2.z + _Wave2.w * t) * _Wave2.y * _Wave2.z;
			// 	dz += _Wave3.x * cos(WaveDirection(x, z, _Wave3.y) * _Wave3.z + _Wave3.w * t) * _Wave3.y * _Wave3.z;
			// 	dz += _Wave4.x * cos(WaveDirection(x, z, _Wave4.y) * _Wave4.z + _Wave4.w * t) * _Wave4.y * _Wave4.z;

			// 	return normalize(float3(-dx, 1, -dz));
			// }

			// float WaveDirection2(float x, float y, float param)
			// {
			// 	return x + param * y;
			// }

			// float3 GetWave2(float x, float z)
			// {
			// 	float3 p;
			// 	p.x = x;
			// 	p.z = z;
			// 	float t = _Time.y;
			// 	p.y = _Wave1.x * sin(WaveDirection2(x, z, _Wave1.y) * _Wave1.z + _Wave1.w * t);
			// 	p.y += _Wave2.x * sin(WaveDirection2(x, z, _Wave2.y) * _Wave2.z + _Wave2.w * t);
			// 	p.y += _Wave3.x * sin(WaveDirection2(x, z, _Wave3.y) * _Wave3.z + _Wave3.w * t);
			// 	p.y += _Wave4.x * sin(WaveDirection2(x, z, _Wave4.y) * _Wave4.z + _Wave4.w * t);

			// 	p.x += _Wave1.x * cos(WaveDirection2(x, z, _Wave1.y) * _Wave1.z + _Wave1.w * t) * _GerstnerQ.x;
			// 	p.x += _Wave2.x * cos(WaveDirection2(x, z, _Wave2.y) * _Wave2.z + _Wave2.w * t) * _GerstnerQ.y;
			// 	p.x += _Wave3.x * cos(WaveDirection2(x, z, _Wave3.y) * _Wave3.z + _Wave3.w * t) * _GerstnerQ.z;
			// 	p.x += _Wave4.x * cos(WaveDirection2(x, z, _Wave4.y) * _Wave4.z + _Wave4.w * t) * _GerstnerQ.w;

			// 	p.z += _Wave1.x * _Wave1.y * cos(WaveDirection2(x, z, _Wave1.y) * _Wave1.z + _Wave1.w * t) * _GerstnerQ.x;
			// 	p.z += _Wave2.x * _Wave2.y * cos(WaveDirection2(x, z, _Wave2.y) * _Wave2.z + _Wave2.w * t) * _GerstnerQ.y;
			// 	p.z += _Wave3.x * _Wave3.y * cos(WaveDirection2(x, z, _Wave3.y) * _Wave3.z + _Wave3.w * t) * _GerstnerQ.z;
			// 	p.z += _Wave4.x * _Wave4.y * cos(WaveDirection2(x, z, _Wave4.y) * _Wave4.z + _Wave4.w * t) * _GerstnerQ.w;

			// 	return p;
			// }

			// float3 GetWaveNormal2(float x, float z)
			// {
			// 	float t = _Time.y;
			// 	float3 normal;
			// 	normal.x = -_Wave1.x * cos(WaveDirection2(x, z, _Wave1.y) * _Wave1.z + _Wave1.w * t) * _Wave1.w;
			// 	normal.x -= _Wave2.x * cos(WaveDirection2(x, z, _Wave2.y) * _Wave2.z + _Wave2.w * t) * _Wave2.w;
			// 	normal.x -= _Wave3.x * cos(WaveDirection2(x, z, _Wave3.y) * _Wave3.z + _Wave3.w * t) * _Wave3.w;
			// 	normal.x -= _Wave4.x * cos(WaveDirection2(x, z, _Wave4.y) * _Wave4.z + _Wave4.w * t) * _Wave4.w;

			// 	normal.z = -_Wave1.x * cos(WaveDirection2(x, z, _Wave1.y) * _Wave1.z + _Wave1.w * t) * _Wave1.w * _Wave1.y;
			// 	normal.z -= _Wave2.x * cos(WaveDirection2(x, z, _Wave2.y) * _Wave2.z + _Wave2.w * t) * _Wave2.w * _Wave2.y;
			// 	normal.z -= _Wave3.x * cos(WaveDirection2(x, z, _Wave3.y) * _Wave3.z + _Wave3.w * t) * _Wave3.w * _Wave3.y;
			// 	normal.z -= _Wave4.x * cos(WaveDirection2(x, z, _Wave4.y) * _Wave4.z + _Wave4.w * t) * _Wave4.w * _Wave4.y;

			// 	normal.y = -_GerstnerQ.x * _Wave1.x * _Wave1.w * cos(WaveDirection2(x, z, _Wave1.y) * _Wave1.z + _Wave1.w * t);
			// 	normal.y -= _GerstnerQ.y * _Wave2.x * _Wave2.w * cos(WaveDirection2(x, z, _Wave2.y) * _Wave2.z + _Wave2.w * t);
			// 	normal.y -= _GerstnerQ.z * _Wave3.x * _Wave3.w * cos(WaveDirection2(x, z, _Wave3.y) * _Wave3.z + _Wave3.w * t);
			// 	normal.y -= _GerstnerQ.w * _Wave4.x * _Wave4.w * cos(WaveDirection2(x, z, _Wave4.y) * _Wave4.z + _Wave4.w * t);
			// 	normal.y += 1;

			// 	return normalize(normal);
			// }


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

				// float3 wave_p = GetWave2(v.vertex.x, v.vertex.z);

				// o.normal = GetWaveNormal2(v.vertex.x, v.vertex.z);

				// o.normal = UnityObjectToWorldNormal(o.normal);

				// o.world_pos = mul(unity_ObjectToWorld, wave_p).xyz;

				// o.vertex = UnityObjectToClipPos(wave_p);
				
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
