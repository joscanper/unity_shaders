using UnityEngine;
using UnityEditor;
using System.Collections;

public class ConeOfSightRaycaster : MonoBehaviour {

	public GameObject ConeOfSight;
	public float SightAngle;
	public float MaxDistance;
	public bool DrawDebug;

	private const int BUFFER_SIZE = 256;
	private Quaternion m_Rotation;
	private float[] m_aDepthBuffer;
	private Material m_ConeOfSightMat;

	void Start () {
		Renderer r = ConeOfSight.GetComponent<Renderer>();
		m_ConeOfSightMat = r.material;

		m_aDepthBuffer = new float[BUFFER_SIZE];
	}

	void FixedUpdate () {
		//if (m_Rotation != this.transform.rotation){
			m_Rotation = this.transform.rotation;
			UpdateViewDepthBuffer();
			//m_ConeOfSightMat.SetFloat("_CurrentAngle", -this.transform.eulerAngles.y);
		//}
	}

	void OnDrawGizmos(){
		Handles.DrawWireArc(this.transform.localPosition,this.transform.up,Vector3.right,360,MaxDistance);

		float halfangle = SightAngle/2 * Mathf.PI / 180;
		float viewangle = this.transform.rotation.eulerAngles.y * Mathf.PI / 180;

		Vector3 p1 = GetVector(-halfangle - viewangle, MaxDistance);
		Vector3 p2 = GetVector(halfangle - viewangle, MaxDistance);

		Debug.DrawRay(this.transform.position, p1);
		Debug.DrawRay(this.transform.position, p2);

	}

	void UpdateViewDepthBuffer(){
		
		float anglestep = SightAngle / BUFFER_SIZE;
		float viewangle = m_Rotation.eulerAngles.y;
		int bufferindex= 0;

		for(int i = 0; i < BUFFER_SIZE; i++){
			float angle = anglestep * i + (viewangle-SightAngle/2);


			Vector3 dest = GetVector(-angle * Mathf.PI / 180, MaxDistance);
			Ray r = new Ray(this.transform.position, dest);
		
			RaycastHit hit = new RaycastHit();
			if(Physics.Raycast(r,out hit)){
				m_aDepthBuffer[bufferindex] = (hit.distance/MaxDistance);
				//if (DrawDebug)
					//Debug.DrawRay(this.transform.position, hit.point,Color.red);
			}else{
				m_aDepthBuffer[bufferindex] = -1;
				if (DrawDebug)
					Debug.DrawRay(this.transform.position, dest);
			}
			bufferindex++;
			
		}

		m_ConeOfSightMat.SetFloatArray("_SightDepthBuffer",m_aDepthBuffer);
	}

	Vector3 GetVector(float angle, float dist){
		float x = Mathf.Cos(angle)*dist;
		float z = Mathf.Sin(angle)*dist;
		return new Vector3(x, 0,z);
	}

}
