Shader "nanase/SavePoint"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_OutlineWidth ("OutlineWidth", Float) = 0.01
		_OutlineColor ("OutlineColor", Color) = (0,0,0,0)
		_BaseColor ("BaseColor", Color) = (1,1,1,0.5)
	}
	SubShader
	{
		Tags{
			"RenderType"="Transparent"
			"Queue"="Transparent"
		}
		LOD 100
		Blend SrcAlpha OneMinusSrcAlpha
		
		// Outline
		Pass
		{
			Cull Front
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal: NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			float _OutlineWidth;
			float4 _OutlineColor;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex + v.normal * _OutlineWidth);
				o.uv = v.uv;
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float4 col = _OutlineColor;
				col.g = 0.9/length(sin(i.uv.y + _Time.y * 0.7));
				return col;
			}
			ENDCG
		}
		// INNER
		Pass
		{
			Cull Front
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal: NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			float _OutlineWidth;
			float4 _OutlineColor;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex + v.normal * 0.001);
				o.uv = v.uv;
				return o;
			}
			
			float3 hsv2rgb(float h, float s, float v) {
				float3 a = frac(h + float3(0.0, 2.0, 1.0)/3.0) * 6.0 - 3.0;
				a = clamp(abs(a) - 1.0, 0.0, 1.0) - 1.0;
				a = a*s + 1.0;
				return a*v;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv;
				uv.x += _Time.y * 0.2;
				float4 col = float4(hsv2rgb(uv.x, 1, 1) , 0.4);
				return col;
			}
			ENDCG
		}
		// INNER2
		Pass
		{
			Cull Front
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal: NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			float _OutlineWidth;
			float4 _OutlineColor;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex + v.normal * 0.0004);
				o.uv = v.uv;
				return o;
			}
			
			float3 hsv2rgb(float h, float s, float v) {
				float3 a = frac(h + float3(0.0, 2.0, 1.0)/3.0) * 6.0 - 3.0;
				a = clamp(abs(a) - 1.0, 0.0, 1.0) - 1.0;
				a = a*s + 1.0;
				return a*v;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv;
				uv.x += _Time.y * 0.5;
				float4 col = float4(hsv2rgb(uv.x, 1, 1) , 0.5);
				return col;
			}
			ENDCG
		}
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _BaseColor;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float4 col = _BaseColor;
				fixed4 tex = tex2D(_MainTex, i.uv);
				return col * tex;
			}
			ENDCG
		}
	}
}
