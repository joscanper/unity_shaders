using UnityEngine;
using System.Collections;

public class Rotation : MonoBehaviour {

	public float Speed= 3000f;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	void FixedUpdate(){
		this.transform.Rotate(Vector3.up * Speed * Time.deltaTime);
	}
}
