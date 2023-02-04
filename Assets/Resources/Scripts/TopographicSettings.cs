using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Effects/Topographic/Settings", fileName = "TopographicSettings")]
public class TopographicSettings : ScriptableObject
{
    [SerializeField]
    private float animationRate = 1f;
    [SerializeField]
    private NoiseLayer topographicNoise;

    public float AnimationRate { get { return animationRate; } }
    public NoiseLayer TopographicNoise { get { return topographicNoise; } }

    private void OnValidate()
    {
        animationRate = Mathf.Max(animationRate, 0f);
        topographicNoise.ValidateConfig();
    }
}