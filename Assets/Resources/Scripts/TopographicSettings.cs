using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Effects/Topographic/Settings", fileName = "TopographicSettings")]
public class TopographicSettings : ScriptableObject
{
    [SerializeField]
    private int numContours;
    [SerializeField]
    private float contourWidth = 1f;
    [SerializeField]
    private float contourSpacing = 0.5f;
    [SerializeField]
    private float animationRate = 1f;

    [Space]

    [SerializeField]
    private Color contourColor;
    [SerializeField]
    private Color mainColor;
    [SerializeField]
    private Color capColor;
    [SerializeField][Range(0f, 1f)]
    private float capHeight = 0.5f;

    [Space]

    [SerializeField]
    private bool debugNoise;
    [SerializeField][Range(0f, 1f)]
    private float heightBias = 1f;
    [SerializeField]
    private NoiseLayer topographicNoise;

    public int NumContours { get { return numContours; } }
    public float ContourWidth { get { return contourWidth; } }
    public float ContourSpacing { get { return contourSpacing; } }
    public float AnimationRate { get { return animationRate; } }
    public Color ContourColor { get { return contourColor; } }
    public Color MainColor { get { return mainColor; } }
    public Color CapColor { get { return capColor; } }
    public float CapHeight { get { return capHeight; } }
    public bool DebugNoise { get { return debugNoise; } }
    public float HeightBias { get { return heightBias; } }
    public NoiseLayer TopographicNoise { get { return topographicNoise; } }

    private void OnValidate()
    {
        numContours = Mathf.Max(numContours, 0);
        contourWidth = Mathf.Max(contourWidth, 0f);
        contourSpacing = Mathf.Max(contourSpacing, 0f);
        animationRate = Mathf.Max(animationRate, 0f);
        topographicNoise.ValidateConfig();
    }
}