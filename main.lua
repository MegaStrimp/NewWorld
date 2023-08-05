--  [VARIABLE SETUP]

local NewWorld = RegisterMod("New World", 1)

--[ITEM SETUPS]

NewWorld.COLLECTIBLE_GREEN_CANDLE = Isaac.GetItemIdByName("Green Candle")
NewWorld.COLLECTIBLE_GRACIOUS_SHAKER = Isaac.GetItemIdByName("Gracious Shaker")
NewWorld.COLLECTIBLE_COFFEE = Isaac.GetItemIdByName("Coffee")
NewWorld.COLLECTIBLE_SLOP = Isaac.GetItemIdByName("Slop")
NewWorld.COLLECTIBLE_PEPPERSPRAY = Isaac.GetItemIdByName("Pepper Spray")
NewWorld.COLLECTIBLE_VOMITCAKE = Isaac.GetItemIdByName("Vomit Cake")
NewWorld.COLLECTIBLE_STEAMJUMPER = Isaac.GetItemIdByName("Steam Jumper")

--[ITEM FUNCTIONALITIES]

function NewWorld:EvaluateCache(player, cacheFlags)
	if cacheFlags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
  
    --[Gracious Shaker]
    
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

    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, NewWorld.COLLECTIBLE_STEAMJUMPER, Vector(320, 300), Vector(0, 0), nil)
  end

  for playerNum = 0, Game():GetNumPlayers() do
    local player = Game():GetPlayer(playerNum)

    --[Steam Jumper]--

    if player:HasCollectible(NewWorld.COLLECTIBLE_STEAMJUMPER) then
      if ((Game():GetFrameCount() % 15) == 0) then
        player:UseActiveItem(CollectibleType.COLLECTIBLE_BUTTER_BEAN, false, false, true, false)
        if ((Input.IsActionPressed(ButtonAction.ACTION_LEFT,0)) or (Input.IsActionPressed(ButtonAction.ACTION_RIGHT,0)) or (Input.IsActionPressed(ButtonAction.ACTION_UP,0)) or (Input.IsActionPressed(ButtonAction.ACTION_DOWN,0))) then
        else
          player:UseActiveItem(CollectibleType.COLLECTIBLE_HOW_TO_JUMP, false, false, true, false)
        end
      end

      if ((Game():GetFrameCount() % 42) == 0) then
        player:UseActiveItem(CollectibleType.COLLECTIBLE_BEAN, false, false, true, false)
      end

      if ((Game():GetFrameCount() % 74) == 0) then
        player:UseActiveItem(CollectibleType.COLLECTIBLE_MEGA_BEAN, false, false, true, false)
      end
    end

    --[Green Candle]--
    
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