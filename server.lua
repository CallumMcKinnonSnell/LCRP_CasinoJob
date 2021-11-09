ESX = nil
-- /* DO NOT EDIT */
--------------
-- ESX Trigger
--------------
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
-------------------
-- Register Society
-------------------
TriggerEvent('esx_society:registerSociety', 'casino', 'Diamond Casino', 'society_casino', 'society_casino', 'society_casino', {type = 'public'})

-- /* END OF DO NOT EDIT */

-- /* Server Callbacks start here */

-------------------------------------------------------------------------------
-- LCRP_getStockItems
-- @param source - integer, the Server ID of the player who initiated callback
-- @param cb - Callback function
--------------------------------------------------------------------------------
ESX.RegisterServerCallback("LCRP_CasinoJob:getStockItems", function(source, cb)
  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_casino', function(inventory)
    cb(inventory.items)
  end)
end)

-------------------------------------------------------------------------------
-- LCRP_getPlayerInventory
-- @param source - integer, the Server ID of the player who initiated callback
-- @param cb - Callback function
--------------------------------------------------------------------------------
ESX.RegisterServerCallback("LCRP_CasinoJob:getPlayerInventory", function(source, cb)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local items = xPlayer.inventory
  cb({items = items})
end)

-- /* Server Events start here */

----------------------------------------------------------------------
-- LCRP_getStockItem
-- @param itemName - String - the name of the item to be withdrawn
-- @param count - integer, the quantity.
----------------------------------------------------------------------
RegisterServerEvent("LCRP_CasinoJob:getStockItem")
AddEventHandler("LCRP_CasinoJob:getStockItem", function(itemName, count)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_casino', function(inventory)
    local storedItem = inventory.getItem(itemName)
    if storedItem then -- if the item is in the storage
      if storedItem.count >= tonumber(count) then -- If the amount they wish to remove is less or equal than the amount in the storage
        inventory.removeItem(itemName, count)
        xPlayer.addInventoryItem(itemName, count)
        local msg =  'You removed ' .. count .. 'x ' ..  item.label 
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = msg, style = { ['background-color'] = '#5aab61', ['color'] = '#000000' } })
      else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Invalid Entry: You are trying to take more than there is.', style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
      end
    else
      TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You are trying to take an item that does not exist! Fuck off.', style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
    end
  end)
end)

----------------------------------------------------------------------
-- LCRP_putStockItem
-- @param itemName - String - the name of the item to be withdrawn
-- @param count - integer, the quantity.
----------------------------------------------------------------------
RegisterNetEvent('LCRP_CasinoJob:putStockItems')
AddEventHandler('LCRP_CasinoJob:putStockItems', function(itemName, count)
  print(itemName)
  print(count)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_casino', function(inventory)
    local item = inventory.getItem(itemName)
    local storingItemCount = xPlayer.getInventoryItem(itemName).count

    if item.count and tonumber(count) <= storingItemCount then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
      local msg = 'You stored ' .. count .. 'x '.. item.label
      TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = msg, style = { ['background-color'] = '#5aab61', ['color'] = '#000000' } })
    else
      TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Invalid Entry: Error with Quantity.', style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
    end
  end)
end)