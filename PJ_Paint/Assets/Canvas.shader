Shader "Custom/Canvas" {
	Properties {
		_PaintTex("Paint Texture", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		
		//La fonction pour dire la couleur de la surface = surf
		//La fonction pour le déplacement de vertex = disp
		//La fonction pour déterminer la tesselation = tessDistance
		#pragma surface surf Standard fullforwardshadows //vertex:disp tessellate:tessDistance

		#pragma target 3.0

		#include "Tessellation.cginc"

		struct appdata {
			float4 vertex :POSITION;
			float4 tangent :TANGENT;
			float3 normal :NORMAL;
			float2 texcoord :TEXCOORD0;
		};
	

		


		sampler2D _PaintTex;


		struct Input {
			float2 uv_PaintTex;
		};

		half _Glossiness;
		half _Metallic;
			


		UNITY_INSTANCING_BUFFER_START(Props)

		UNITY_INSTANCING_BUFFER_END(Props)
		//fonction qui détermine la couleur
		void surf (Input IN, inout SurfaceOutputStandard o) {
			//On lit la texture splat pour s'avoir si la neige est enfoncée.
			//Si le rouge est au maximum, cela veut dire qu'on doit prendre la texture de glace * couleur de glace
			//si le rouge est à 0, cela veut dire qu'on doit prendre la texture de neige * la couleur de neige
			//si le rouge est à 0,5, cela veut dire quon doit avoir une couleur à mi-chemin entre la glace et la neige
			
			
			fixed4 c = tex2D(_PaintTex, IN.uv_PaintTex);
			o.Albedo = c.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
