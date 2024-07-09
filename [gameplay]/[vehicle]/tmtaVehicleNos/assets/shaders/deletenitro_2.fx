
texture gTexture0           < string textureState="0,Texture"; >;

sampler Sampler1 = sampler_state
{
    Texture         = (gTexture0);
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
};

struct PSInput
{
  float4 Position : POSITION0;
  float4 Diffuse : COLOR0;
  float2 TexCoord : TEXCOORD0;
};
float4 PixelShaderFunction(PSInput PS) : COLOR
{
    float4 finalColor = tex2D(Sampler1, PS.TexCoord);
    finalColor.a *= sqrt(
        abs(0.5 - PS.TexCoord.x)
        + abs(0.5 - PS.TexCoord.y)
    )/6;

    // return float4(1, 0, 0, PS.Diffuse.a);
    return finalColor;
}


technique tec0
{
    pass P0
    {
        PixelShader  = compile ps_2_0 PixelShaderFunction();
    }
}
