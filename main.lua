--[REGISTER]--

local NewWorld = RegisterMod("New World", 1)

--[ITEM SETUPS]--

NewWorld.COLLECTIBLE_GREEN_CANDLE = Isaac.GetItemIdByName("Green Candle")
NewWorld.COLLECTIBLE_GRACIOUS_SHAKER = Isaac.GetItemIdByName("Gracious Shaker")
NewWorld.COLLECTIBLE_COFFEE = Isaac.GetItemIdByName("Coffee")
NewWorld.COLLECTIBLE_SLOP = Isaac.GetItemIdByName("Slop")

--[ITEM FUNCTIONALITIES]--

function NewWorld:EvaluateCache(player, cacheFlags)
	if cacheFlags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
  
    --[Gracious Shaker]--
    
		local itemCount = player:GetCollectibleNum(NewWorld.COLLECTIBLE_GRACIOUS_SHAKER)
		local valueToAdd = 1 * itemCount
		player.Damage = player.Damage + valueToAdd

  end

  if cacheFlags & CacheFlag.CACHE_SPEED == CacheFlag.CACHE_SPEED then

    --[Coffee]--
    
    local itemCount = player:GetCollectibleNum(NewWorld.COLLECTIBLE_COFFEE)
    local valueToAdd = 0.4 * itemCount
    player.MoveSpeed = player.MoveSpeed + valueToAdd

  end
end

function NewWorld:onUpdate()

  --[FIRST FRAME OF THE RUN]--

  if Game():GetFrameCount() == 1 then

    --[SET ITEM VARIABLES]--

    NewWorld.HasGreenCandle = false

    --[CREATE ITEM IN PEDESTAL]--

    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, NewWorld.COLLECTIBLE_SLOP, Vector(320, 300), Vector(0, 0), nil)
  end

  --[Green Candle]--
  
  for playerNum = 0, Game():GetNumPlayers() do
    local player = Game():GetPlayer(playerNum)
    if player:HasCollectible(NewWorld.COLLECTIBLE_GREEN_CANDLE) then
      if not NewWorld.HasGreenCandle then --Initial pickup
        player:AddSoulHearts(2)
        NewWorld.HasGreenCandle = true
        --print("[MOD]: Green Candle picked up")
      end

      for i,entity in pairs(Isaac.GetRoomEntities()) do -- Ongoing
        if entity:IsVulnerableEnemy() and math.random(500) <= 7 then
          entity:AddBurn(EntityRef(player), 100, 3.5)
        end
      end
    end
  end
end

--[ADD CALLBACKS]--

NewWorld:AddCallback(ModCallbacks.MC_POST_UPDATE, NewWorld.onUpdate)
NewWorld:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, NewWorld.EvaluateCache)







--function NewWorld:immortality(_NewWorld)
--	local player = Isaac.GetPlayer(0)
--	player:SetFullHearts()
--	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, 1, player.Position, player.Velocity, player)
--end

-- NewWorld:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, NewWorld.immortality, EntityType.ENTITY_PLAYER)
-- When an entity takes damage (ModCallbacks.MC_ENTITY_TAKE_DMG)
-- Run "immortality" (NewWorld.immortality)
-- If that entity is player (EntityType.ENTITY_PLAYER)