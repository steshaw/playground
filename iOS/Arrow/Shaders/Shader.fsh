//
//  Shader.fsh
//  Arrow
//
//  Created by Steven Shaw on 24/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
