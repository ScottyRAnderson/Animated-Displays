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
        material.SetFloat("_NumContours", settings.NumContours);
        material.SetFloat("_ContourWidth", settings.ContourWidth);
        material.SetFloat("_ContourSpacing", settings.ContourSpacing);
        material.SetFloat("_AnimRate", settings.AnimationRate);

        material.SetColor("_ContourColor", settings.ContourColor);
        material.SetColor("_MainColor", settings.MainColor);
        material.SetColor("_CapColor", settings.CapColor);
        material.SetFloat("_CapHeight", Mathf.Lerp(-2f, 2f, settings.CapHeight));
        material.SetFloat("_NoiseColor", settings.NoiseColor);

        if (settings.DebugNoise){
            material.EnableKeyword("DEBUGNOISE");
        }
        else{
            material.DisableKeyword("DEBUGNOISE");
        }
        material.SetFloat("_NoiseScale", settings.TopographicNoise.NoiseScale);
        material.SetInt("_Octaves", settings.TopographicNoise.Octaves);
        material.SetFloat("_Persistance", settings.TopographicNoise.Persistance);
        material.SetFloat("_Lacunarity", settings.TopographicNoise.Lacunarity);
        material.SetFloat("_HeightScalar", settings.TopographicNoise.HeightScalar);
    }
}