require_relative "common"

class Cat
  def initialize
    @cat = $game.add.sprite(0, 0, "cat")
    @cat.anchor.set(0.5, 0.5)
    @phase = 0
  end

  def update(dt)
    @phase -= dt
    @cat.x = ( 0.5 + 0.4 * Math.sin(@phase) ) * $size_x
    @cat.y = ( 0.5 + 0.4 * Math.cos(@phase) ) * $size_y
  end

  def x
    @cat.x
  end

  def y
    @cat.y
  end
end

class MainState < Phaser::State
  def fragment_src
    """
    precision mediump float;

    uniform float time;
    uniform vec2 mouse;
    uniform vec2 resolution;
    uniform sampler2D backbuffer;


    // Yuldashev Mahmud (remake from https://www.shadertoy.com/view/4dXGR4) mahmud9935@gmail.com
    float snoise(vec3 uv, float res)	// by trisomie21
    {
    	const vec3 s = vec3(1e0, 1e2, 1e4);

    	uv *= res;

    	vec3 uv0 = floor(mod(uv, res))*s;
    	vec3 uv1 = floor(mod(uv+vec3(1.), res))*s;

    	vec3 f = fract(uv); f = f*f*(3.0-2.0*f);

    	vec4 v = vec4(uv0.x+uv0.y+uv0.z, uv1.x+uv0.y+uv0.z,
    		      	  uv0.x+uv1.y+uv0.z, uv1.x+uv1.y+uv0.z);

    	vec4 r = fract(sin(v*1e-3)*1e5);
    	float r0 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);

    	r = fract(sin((v + uv1.z - uv0.z)*1e-3)*1e5);
    	float r1 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);

    	return mix(r0, r1, f.z)*2.-1.;
    }

    float freqs[4];

    void main(void)
    {
    	freqs[0] = texture2D( backbuffer, vec2( 0.01, 0.25 ) ).x;
    	freqs[1] = texture2D( backbuffer, vec2( 0.07, 0.25 ) ).x;
    	freqs[2] = texture2D( backbuffer, vec2( 0.15, 0.25 ) ).x;
    	freqs[3] = texture2D( backbuffer, vec2( 0.30, 0.25 ) ).x;
    	float brightness	= freqs[1] * 0.25 + freqs[2] * 0.25;
    	float radius		= 0.24 + brightness * 0.2;
    	float invRadius 	= 1.0 / radius;

    	vec3 orange			= vec3( 0.8, 0.65, 0.3 );
    	vec3 orangeRed		= vec3( 0.8, 0.35, 0.1 );
    	float time		= time * 0.1;
    	float aspect	= resolution.x / resolution.y;
      // rescale -0.5..0.5 to -2..2
    	vec2 uv			= (gl_FragCoord.xy / resolution.xy) * 4.0 - 1.5;
    	vec2 p 			= (-0.5 + uv);
    	p.x *= aspect;

    	float fade		= pow( length( 2.0 * p ), 0.5 );
    	float fVal1		= 1.0 - fade;
    	float fVal2		= 1.0 - fade;

    	float angle		= atan( p.x, p.y )/6.2832;
    	float dist		= length(p);
    	vec3 coord		= vec3( angle, dist, time * 0.1 );

    	float newTime1	= abs( snoise( coord + vec3( 0.0, -time * ( 0.35 + brightness * 0.001 ), time * 0.015 ), 15.0 ) );
    	float newTime2	= abs( snoise( coord + vec3( 0.0, -time * ( 0.15 + brightness * 0.001 ), time * 0.015 ), 45.0 ) );
    	for( int i=1; i<=7; i++ ){
    		float power = pow( 2.0, float(i + 1) );
    		fVal1 += ( 0.5 / power ) * snoise( coord + vec3( 0.0, -time, time * 0.2 ), ( power * ( 10.0 ) * ( newTime1 + 1.0 ) ) );
    		fVal2 += ( 0.5 / power ) * snoise( coord + vec3( 0.0, -time, time * 0.2 ), ( power * ( 25.0 ) * ( newTime2 + 1.0 ) ) );
    	}

    	float corona		= pow( fVal1 * max( 1.1 - fade, 0.0 ), 2.0 ) * 50.0;
    	corona				+= pow( fVal2 * max( 1.1 - fade, 0.0 ), 2.0 ) * 50.0;
    	corona				*= 1.2 - newTime1;
    	vec3 sphereNormal 	= vec3( 0.0, 0.0, 1.0 );
    	vec3 dir 			= vec3( 0.0 );
    	vec3 center			= vec3( 0.5, 0.5, 1.0 );
    	vec3 starSphere		= vec3( 0.0 );

    	vec2 sp = -1.0 + 2.0 * uv;
    	sp.x *= aspect;
    	sp *= ( 2.0 - brightness );
      	float r = dot(sp,sp);
    	float f = (1.0-sqrt(abs(1.0-r)))/(r) + brightness * 0.5;
    	if( dist < radius ){
    		corona			*= pow( dist * invRadius, 24.0 );
      		vec2 newUv;
     		newUv.x = sp.x*f;
      		newUv.y = sp.y*f;
    		newUv += vec2( time, 0.0 );

    		vec3 texSample 	= texture2D( backbuffer, newUv ).rgb;
    		float uOff		= ( texSample.g * brightness * 4.5 + time );
    		vec2 starUV		= newUv + vec2( uOff, 0.0 );
    		starSphere		= texture2D( backbuffer, starUV ).rgb;
    	}

    	float starGlow	= min( max( 1.0 - dist * ( 1.0 - brightness ), 0.0 ), 1.0 );
    	//gl_FragColor.rgb	= vec3( r );
    	gl_FragColor.rgb	= vec3( f * ( 0.75 + brightness * 0.5 ) * orange ) + starSphere + corona * orange + starGlow * orangeRed;
    	gl_FragColor.a		= 1.0;
    }
    """
  end

  def preload
    $game.load.image("cat", "/images/cat_images/cat4.png")
  end

  def create
    $game.stage.background_color = "000"

    @filter = Phaser::Filter.new($game, nil, fragment_src)
    @filter.set_resolution($size_x, $size_y)
    @sprite = $game.add.sprite($size_x/2, $size_y/2)
    @sprite.anchor.set(0.5, 0.5)
    @sprite.width = $size_x/2
    @sprite.height = $size_y/2
    @sprite.filters = [ @filter ]

    @cat = Cat.new
  end

  def update
    dt = $game.time.physics_elapsed
    @cat.update(dt)
    @filter.update
  end
end

$game.state.add(:main, MainState.new, true)
