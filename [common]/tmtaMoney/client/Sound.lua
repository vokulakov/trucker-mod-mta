local Sound = {}

addEventHandler("tmtaMoney.onPlayerGiveMoney", root, function()
    exports.tmtaSounds:playSound('sell')
end)

addEventHandler("tmtaMoney.onPlayerTakeMoney", root, function()
    exports.tmtaSounds:playSound('sell')
end)