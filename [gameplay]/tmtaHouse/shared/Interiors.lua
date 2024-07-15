Interiors = {}

--@link https://wiki.multitheftauto.com/wiki/Interior_IDs

Interiors.list = {

    [1] = {
        name = 'Обычный #1',

        interior = 5,
        interiorName = 'Vank Hoff Hotel room',
        interiorImage = 'assets/images/interiors/interior01.jpg',
        
        entry = { -- позиция входа
            position = Vector3(2233.538086, -1112.498047, 1050.882812), 
            rotation = Vector3(0, 0, 0) 
        },

        exit = Vector3(2233.65, -1115.15, 1050), -- позиция выхода
        managementPosition = Vector3(2230.25, -1108.62, 1050), -- позиция управления домом
    },

    [2] = {
        name = 'Средний #1',

        interior = 8,
        interiorName = 'Colonel Fuhrberger\'s House',
        interiorImage = 'assets/images/interiors/interior02.jpg',
        
        entry = { -- позиция входа
            position = Vector3(2807.67, -1171.90, 1025.57), 
            rotation = Vector3(0, 0, 0) 
        },
        
        exit = Vector3(2807.61, -1174.38, 1024.8), -- позиция выхода
        managementPosition = Vector3(2817.107, -1173.585, 1024.570), -- позиция управления домом
    },

    [3] = {
        name = 'Элитный #1',

        interior = 12,
        interiorName = 'Modern safe house',
        interiorImage = 'assets/images/interiors/interior03.jpg',

        entry = { -- позиция входа
            position = Vector3(2324.612305, -1145.409180, 1050.710083), 
            rotation = Vector3(0, 0, 0) 
        },
        
        exit = Vector3(2324.467773, -1149.544922, 1049.8), -- позиция выхода
        managementPosition = Vector3(2336.529, -1145.670, 1049.710), -- позиция управления домом
    },

}

function Interiors.getList()
    return Interiors.list
end

function Interiors.get(interiorId)
    if type(interiorId) ~= 'number' then
        outputDebugString("Interiors.get: bad arguments", 1)
        return false
    end
    return Interiors.list[interiorId]
end