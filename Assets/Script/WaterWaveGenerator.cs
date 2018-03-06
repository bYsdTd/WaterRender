using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterWaveGenerator : MonoBehaviour {

	public GameObject water_object;

	Material	mat_water;

	Vector4 wave1_param;
	Vector4 wave2_param;
	Vector4 wave3_param;
	Vector4 wave4_param;

	// Use this for initialization
	void Start () 
	{
		MeshRenderer mesh_renderer = water_object.GetComponent<MeshRenderer>();

		mat_water = mesh_renderer.material;

		// x 振幅
		// y 波长
		// z 速度
		// w 方向角度 0 - 360
		wave1_param = new Vector4(0.1f, 10, 2, 40);
		wave2_param = new Vector4(0.1f, 10, 2, 90);
		wave3_param = new Vector4(0.1f, 10, 2, 40);
		wave4_param = new Vector4(0.1f, 10, 2, 90);

		SetWaterParam();
	}
	
	void SetWaterParam()
	{
		mat_water.SetVector("_Wave1", wave1_param);
		mat_water.SetVector("_Wave2", wave2_param);
		mat_water.SetVector("_Wave3", wave3_param);
		mat_water.SetVector("_Wave4", wave4_param);
	}

	// Update is called once per frame
	void Update () {
		
	}
}
