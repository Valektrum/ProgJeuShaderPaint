Shader "Unlit/Paint"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Coordinate("Coordinate", Vector) = (0,0,0,0)
		_Color("Draw Color", Color) = (1,1,0,0)
		_Size("Brush Size", Range(1,500)) = 1
		_Strength("Brush Strength", Range(0,1)) = 1
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }
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
					float2 uv : TEXCOORD0;
				};

				struct v2f
				{
					float2 uv : TEXTCOORD0;
					float4 vertex : SV_POSITION;
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;
				fixed4 _Coordinate, _Color;
				half _Size, _Strength;

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					//_MainTex est la texture du splat
					//_Coordinate est la coordonnée où l'on souhaite écrire
					fixed4 col = tex2D(_MainTex, i.uv);
				//distance retourne la distance entre 2 points, si jamais on souhaite écrire à plus de 1 unité
				//Avec la fonction pow (exposé) un gros exposant, les points ayant une valeur trop faible seront réduit presque à 0
				//
			float draw = pow(saturate(1 - distance(i.uv, _Coordinate.xy)), 500 / _Size);
			fixed4 drawCol = _Color * (draw * _Strength);
				return saturate(col + drawCol);
			}
			ENDCG
		}
		}
}