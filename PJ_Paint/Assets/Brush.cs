using JetBrains.Annotations;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Brush : MonoBehaviour
{
	public Shader paint;
	public GameObject plane;
	private int layerMask;

	[Range(0, 4)]
	public float brushSize;

	[Range(0, 1)]
	public float brushStrength;

	private RenderTexture paintTexture;
	private Material drawMaterial, canvasMaterial;

	public Camera camera;

	// Start is called before the first frame update
	private void Start()
	{
		layerMask = LayerMask.GetMask("Canvas");
		drawMaterial = new Material(paint);
		canvasMaterial = plane.GetComponent<MeshRenderer>().material;
		paintTexture = new RenderTexture(1024, 1024, 0, RenderTextureFormat.ARGBFloat);
		canvasMaterial.SetTexture("_PaintTex", paintTexture);
	}

	// Update is called once per frame
	private void Update()
	{
		RaycastHit hit;
		Ray ray = GetComponent<Camera>().ScreenPointToRay(Input.mousePosition);
		if (Input.GetAxis("Fire1") != 0)
		{
			if (Physics.Raycast(ray, out hit, layerMask))
			{
				drawMaterial.SetVector("_Coordinate", new Vector4(hit.textureCoord.x, hit.textureCoord.y, 0, 0));
				drawMaterial.SetFloat("_Size", brushSize);
				drawMaterial.SetFloat("_Strength", brushStrength);
				RenderTexture temp = RenderTexture.GetTemporary(paintTexture.width, paintTexture.height, 0, RenderTextureFormat.ARGBFloat);
				Graphics.Blit(paintTexture, temp);
				Graphics.Blit(temp, paintTexture, drawMaterial);
				RenderTexture.ReleaseTemporary(temp);
			}
		}
	}

	public void SetColorRed()
	{
		Vector3 newColor = new Vector3(1, 0, 0);
		drawMaterial.SetVector("_Color", new Vector4(newColor.x, newColor.y, newColor.z, 1));

		//ligne manquante
	}

	public void SetColorGreen()
	{
		Vector3 newColor = new Vector3(0, 1, 0);
		//ligne manquante
		drawMaterial.SetVector("_Color", new Vector4(newColor.x, newColor.y, newColor.z, 1));
	}

	public void SetColorBlue()
	{
		Vector3 newColor = new Vector3(0, 0, 1);
		drawMaterial.SetVector("_Color", new Vector4(newColor.x, newColor.y, newColor.z, 1));

		//ligne manquante
	}
}