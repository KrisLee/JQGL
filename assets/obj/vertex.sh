uniform mat4 sMVPMatrix; //总变换矩阵
uniform mat4 sChangeMatrix;//变化矩阵
uniform vec3 sLightlocation;//光源位置
uniform vec3 sCreamLocation;//摄像机位置

attribute vec3 sPosition;  //顶点位置
attribute vec2 sTexture;//顶点纹理坐标
attribute vec3 sNormalVector;//顶点法向量


varying vec4 vDiffLight;//传递给片元着色器的散射光强度
varying vec4 vSpecLight;//镜面光强度
varying vec4 vEnviLight;//环境光强度

varying vec2 vTexture;//传递给片元着色器的纹理坐标

void getLight(){
	
	//环境光
	vEnviLight = vec4(0.1,0.1,0.1,1.0);
	//散射光
	vec4 diffli = vec4(0.7,0.7,0.7,1.0);
	//镜面光
	vec4 specular = vec4(0.3,0.3,0.3,1.0);
	
	//0 求出未变化前法向量的点
	vec3 faD = sNormalVector + sPosition;

	//1 规格化法向量
	vec3 faX = normalize((sChangeMatrix * vec4(faD,1)).xyz - (sChangeMatrix * vec4(sPosition,1)).xyz);

	//2 规格化光源向量
        vec3 lightX = normalize(sLightlocation - (sChangeMatrix * vec4(sPosition,1)).xyz);

	//求法向量与光源向量的点积
	float cosLight = max(dot(faX,lightX),0.0);
	
	//求出最终的散射光强度
	vDiffLight = diffli * cosLight;

	//镜面光处理
	//1 规格化观察点向量
	vec3 lookLocation = normalize(sCreamLocation - (sChangeMatrix * vec4(sPosition,1)).xyz);

	//2 求出观察点向量与光源向量的半向量
	vec3 halfx = normalize(lookLocation + lightX);

	//3 求出半向量与法向量的点积
	float cosSpeLight = dot(halfx,faX);
	
	//反射因子
	float fanSe = 50.0;

	//4 求出最终镜面光强度
	vSpecLight = specular * max(0.0,pow(cosSpeLight,fanSe));

}
void main()     
{                            		
   gl_Position = sMVPMatrix * vec4(sPosition,1); //根据总变换矩阵计算此次绘制此顶点位置
   vTexture = sTexture;
   getLight();
}                      