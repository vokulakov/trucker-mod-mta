Resource: Shader water refract test 2
Author: Ren712
Attention!
----------
This resource's main purpose is to test depth buffer with multisampling.
Please turn on and turn off antialiasing to see if the resource works.
If you see any error messages (besides :Uncompatible with this MTA version)
please post them in the comments section - paste your video card name.
----------
This shader uses some vertex and pixel calculations from water_shader by Ccw.
http://wiki.multitheftauto.com/wiki/Shader_examples
Unlike previous water refract shader it uses depth texture image for refraction 
instead of screensource.

It doesn't look as nice as previous 'Shader water refract test' but it works properly.
So the effect can be drawn in 1 pass and it works with all other resources that 
create full screen effects (like bloom and contrast).

There are some artefacts that will be fixed in full version.

A recent MTA version (1.3.1-9.04710.0) will NOT WORK.
This resource REQUIRES a recent nightly MTA version (1.3.0-9.04811)
So get the latest nightly before downloading- even if the depthbuffer is readable.

It might not work on some older GFX (especially INTEL).
It is due to Zbuffer usage.

-- Reading depth buffer supported by:
-- NVidia - from GeForce 6 (2004)
-- Radeon - from 9500 (2002)
-- Intel - from G45 (2008)

That's all. 
Have fun.
Ren712
knoblauch700@o2.pl

