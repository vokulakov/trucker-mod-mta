BlipTextures = {}

function BlipTextures.getList()
    return {
        blipMarker          = Texture.create('blipMarker'),
        blipMarkerHigher    = Texture.create('blipMarkerHigher'),
        blipMarkerLower     = Texture.create('blipMarkerLower'),
        blipProperty        = Texture.create('blipProperty'),
        blipGasStation      = Texture.create('blipGasStation'),
        blipClothes         = Texture.create('blipClothes'),
        blipSto             = Texture.create('blipSto'),
        blipCarshop         = Texture.create('blipCarshop'),
        blipTuning          = Texture.create('blipTuning'),
        blipScooterRent     = Texture.create('blipScooterRent'),
        blipRestaurant      = Texture.create('blipRestaurant'),
        blipPaint           = Texture.create('blipPaint'),
        blipNumberPlate     = Texture.create('blipNumberPlate'),
        blipTrucker         = Texture.create('blipTrucker'),
        blipCheckpoint      = Texture.create('blipCheckpoint'),
        blipHospital        = Texture.create('blipHospital'),
        blipBusiness        = Texture.create('blipBusiness'),
        blipRevenueService  = Texture.create('blipRevenueService'),
        blipJobLoader       = Texture.create('blipJobLoader'),
    }
end

-- exports
getBlipTextures = BlipTextures.getList