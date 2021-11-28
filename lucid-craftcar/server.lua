
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)





ESX.RegisterServerCallback('wiz-server:checkKey', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items   =  xPlayer.inventory
    cb({items = items})
end)


ESX.RegisterServerCallback('propgressbar', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    exports.ghmattimysql:execute('SELECT * FROM users WHERE identifier = @kartno', {
        ['@kartno'] = xPlayer.identifier
    }, function(results)
        local user = results[1]
        cb(user)

    end)
end)



RegisterServerEvent('lucid:insertVehToData')
AddEventHandler('lucid:insertVehToData', function(vehicleProps)
    local ply = ESX.GetPlayerFromId(source)

	exports.ghmattimysql:execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@steam,@citizenid, @plate)', {
		['@steam']   = ply.identifier,
		['@citizenid']   = vehicleProps.plate,
		['@plate']   = json.encode(vehicleProps)
	}, function()

	end)


end)



RegisterServerEvent('lucid-carcraft:removeItem')
AddEventHandler('lucid-carcraft:removeItem', function(item)
    local ply = ESX.GetPlayerFromId(source)
    ply.removeInventoryItem(item, 1)
end)

RegisterCommand('createcars', function(source)

    createCars(source)
end)

function createCars(source)
    local cars = {};
    for k,v in pairs(araclar) do
        cars[k] = {
            label = v.name,
            reqItem = {
                v.model.."_blueprint"
            },
        }
    end
    TriggerClientEvent('lucid-craftcar:requestCars', source, cars)

end


RegisterServerEvent('lucid-craftCar:craftCarObject')
AddEventHandler('lucid-craftCar:craftCarObject', function(prop, bone, xpos, ypos, zpos, xrot,yrot,zrot,dict, anim, progress, reqItems)
    local src = source
    local ply = ESX.GetPlayerFromId(source)
    for k,v in pairs(reqItems) do
       local item = ply.getInventoryItem(k)
       if item == nil or item.count < tonumber(v.reqAmount) then
            TriggerClientEvent('ESX:Notify', src, "You don't have enough item to craft.", "error")
            return
       end  
    end
     for k,v in pairs(reqItems) do
        ply.removeInventoryItem(k, v.reqAmount)
     end
     TriggerClientEvent('lucid-craftCar-client:craftCarObject', src, prop, bone, xpos, ypos, zpos, xrot,yrot,zrot,dict, anim, progress)
end)


RegisterServerEvent('aracimikaydet')
AddEventHandler('aracimikaydet', function(model)

    ply = ESX.GetPlayerFromId(source)

    exports.ghmattimysql:execute('UPDATE users SET craftname = @craftname WHERE identifier = @identifier',
    {
        ['@craftname'] = model,
        ['@identifier'] = ply.identifier
    })

end)


RegisterServerEvent('nerdeyimkaydet')
AddEventHandler('nerdeyimkaydet', function(gelenrakam)

    ply = ESX.GetPlayerFromId(source)

    exports.ghmattimysql:execute('UPDATE users SET craftcar = @craftname WHERE identifier = @identifier',
    {
        ['@craftname'] = gelenrakam,
        ['@identifier'] = ply.identifier
    })

end)


ESX.RegisterServerCallback('caritemkontrol', function(source, cb, item)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local itemla = xPlayer.getInventoryItem(item)
    cb(itemla)
end)