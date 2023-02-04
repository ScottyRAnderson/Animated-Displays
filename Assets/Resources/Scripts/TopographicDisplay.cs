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
    }
}