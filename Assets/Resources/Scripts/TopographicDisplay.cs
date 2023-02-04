using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TopographicDisplay : Display
{
    [SerializeField]
    private TopographicSettings settings;

    protected override void Awake(){
        base.Awake();
    }

    protected override void UpdateMaterial()
    {
        Init();

        // Set material properties
        material.SetFloat("_AnimRate", settings.AnimationRate);

        material.SetFloat("_NoiseScale", settings.TopographicNoise.NoiseScale);
        material.SetInt("_Octaves", settings.TopographicNoise.Octaves);
        material.SetFloat("_Persistance", settings.TopographicNoise.Persistance);
        material.SetFloat("_Lacunarity", settings.TopographicNoise.Lacunarity);
        material.SetFloat("_HeightScalar", settings.TopographicNoise.HeightScalar);
    }
}