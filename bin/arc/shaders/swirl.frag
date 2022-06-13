/*
 * Original shader from: https://www.shadertoy.com/view/Wscyz2
 */
#ifdef GL_ES
precision highp float;
#endif

// glslsandbox uniforms
uniform float u_time;
uniform vec2 u_resolution;

// shadertoy emulation
#define iTime u_time
#define iResolution u_resolution

// --------[ Original ShaderToy begins here ]---------- //

    
#define PI 3.14159
#define    TAU 6.28318

vec3 punk(vec2 uv)
{
    vec3 col = vec3(.55,0.35,1.225);		// Drop Colour
    uv.x += sin(0.2+uv.y*0.8)*0.5;
    uv.x = uv.x*50.0;						// H-Count
    float dx = fract(uv.x);
    uv.x = floor(uv.x);
    float t =  iTime*0.4;
    uv.y *= 0.15;							// stretch
    float o=sin(uv.x*21005.4);				// offset
    float s=cos(uv.x*33.1)*.3 +.7;			// speed
    float trail = mix(95.0,35.0,s);			// trail length
    float yv = fract(uv.y + t*s + o) * trail;
    yv = 1.0/yv;
    yv = smoothstep(0.0,1.0,yv*yv);
    yv = sin(yv*PI)*(s*5.0);
    float d2 = sin(dx*PI);
    yv *= d2*d2;
    col = col*yv;
	return col;
}

void main(void)
{
    vec2 ppp = (-iResolution.xy + 2.*(gl_FragCoord.xy))/iResolution.y;
	ppp.x *= 0.8+sin(ppp.y*0.1+u_time)*.4;
    vec3 bbk = punk(sin(ppp.xy));
    gl_FragColor = vec4( bbk, 100.0 );

}