using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshRenderer))][ExecuteInEditMode]
public class Display : MonoBehaviour
{
    [SerializeField]
    protected Shader effectShader;
    [SerializeField]
    protected MeshRenderer display;

    protected Material material;

    protected virtual void Awake(){
        display = GetComponent<MeshRenderer>(); 
    }

    protected virtual void OnValidate(){
        UpdateMaterial();
    }

    protected virtual void Init()
    {
        if(effectShader == null){
            return;
        }

        if(material == null){
            material = new Material(effectShader);
        }
        display.material = material;
    }

    protected virtual void UpdateMaterial(){
        Init();
    }
}