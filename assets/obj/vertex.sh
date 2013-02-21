uniform mat4 sMVPMatrix; //�ܱ任����
uniform mat4 sChangeMatrix;//�仯����
uniform vec3 sLightlocation;//��Դλ��
uniform vec3 sCreamLocation;//�����λ��

attribute vec3 sPosition;  //����λ��
attribute vec2 sTexture;//������������

attribute vec3 sNormalVector;//���㷨����


varying vec4 vDiffLight;//���ݸ�ƬԪ��ɫ����ɢ���ǿ��
varying vec4 vSpecLight;//�����ǿ��
varying vec4 vEnviLight;//������ǿ��

varying vec2 vTexture;//���ݸ�ƬԪ��ɫ������������

void getLight(){
	
	//������
	vEnviLight = vec4(0.1,0.1,0.1,1.0);
	//ɢ���
	vec4 diffli = vec4(0.7,0.7,0.7,1.0);
	//�����
	vec4 specular = vec4(0.3,0.3,0.3,1.0);
	
	//0 ���δ�仯ǰ�������ĵ�
	vec3 faD = sNormalVector + sPosition;

	//1 ��񻯷�����
	vec3 faX = normalize((sChangeMatrix * vec4(faD,1)).xyz - (sChangeMatrix * vec4(sPosition,1)).xyz);

	//2 ��񻯹�Դ����
        vec3 lightX = normalize(sLightlocation - (sChangeMatrix * vec4(sPosition,1)).xyz);

	//���������Դ�����ĵ��
	float cosLight = max(dot(faX,lightX),0.0);
	
	//������յ�ɢ���ǿ��
	vDiffLight = diffli * cosLight;

	//����⴦��
	//1 ��񻯹۲������
	vec3 lookLocation = normalize(sCreamLocation - (sChangeMatrix * vec4(sPosition,1)).xyz);

	//2 ����۲���������Դ�����İ�����
	vec3 halfx = normalize(lookLocation + lightX);

	//3 ����������뷨�����ĵ��
	float cosSpeLight = dot(halfx,faX);
	
	//��������
	float fanSe = 50.0;

	//4 ������վ����ǿ��
	vSpecLight = specular * max(0.0,pow(cosSpeLight,fanSe));

}
void main()     
{                            		
   gl_Position = sMVPMatrix * vec4(sPosition,1); //�����ܱ任�������˴λ��ƴ˶���λ��
   vTexture = sTexture;
   getLight();
}                      