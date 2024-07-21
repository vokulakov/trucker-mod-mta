Vehicle = {}

VEHICLE_TABLE_NAME = 'vehicle'

function Vehicle.setup()
    exports.tmtaSQLite:dbTableCreate(HOUSE_TABLE_NAME, {
        { name = "position", type = "TEXT" },
    })
end