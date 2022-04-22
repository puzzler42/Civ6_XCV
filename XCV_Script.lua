-- -----------------------------------------------------------------------------
-- Variables from game config
local PROD_MULT = GameConfiguration.GetValue("CONFIG_XCV_PRODUCTION_MULTIPLIER");
--local XCV_BONUSES = GameConfiguration.GetValue("CONFIG_XCV_BONUSES");
local XCV_ENABLED = GameConfiguration.GetValue("CONFIG_XCV");

-- Local variables
local dummyBuildingIndexPlus1 = 0;
local dummyBuildingIndexPlus10 = 0;
local dummyBuildingIndexPlus100 = 0;
local dummyBuildingIndexMinus1 = 0;
local dummyBuildingIndexMinus10 = 0;

local dummyBonusPolicyIndex1 = 0;
local dummyBonusPolicyIndex2 = 0;
local dummyBonusPolicyIndex3 = 0;

local qtyDummyPlus1 = 0;
local qtyDummyPlus10 = 0;
local qtyDummyPlus100 = 0;
local qtyDummyMinus1 = 0;
local qtyDummyMinus10 = 0;
local multDiff = 0;
local speedDiff = 0;

if (PROD_MULT ~= nil) then
	if (type(PROD_MULT) ~= "number") then
		PROD_MULT = tonumber(PROD_MULT);
	end
	if(PROD_MULT < 100) then
		speedDiff = 100-PROD_MULT;
		multDiff = 100*speedDiff/PROD_MULT;
		qtyDummyPlus100 = math.floor(multDiff/100);
		qtyDummyPlus10 = math.floor(multDiff/10)- 10*qtyDummyPlus100;
		qtyDummyPlus1 = math.floor(multDiff) - 100*qtyDummyPlus100 - 10*qtyDummyPlus10;
	end
	if(PROD_MULT > 100) then
		speedDiff = PROD_MULT-100;
		multDiff = 100*speedDiff/PROD_MULT;
		qtyDummyMinus10 = math.floor(multDiff/10);
		qtyDummyMinus1 = math.floor(multDiff) - 10*qtyDummyMinus10;
	end
end	

local dummyQtys = {qtyDummyPlus1, qtyDummyPlus10, qtyDummyPlus100, qtyDummyMinus1, qtyDummyMinus10};
local indexToCheck = 0;
for j=1,5 do
	if dummyQtys[j] > 0 then
		indexToCheck = j;
		break;
	end
end

-- -----------------------------------------------------------------------------
function XCV_Initialize()
	print("XCV_Script initialized");
	print("Multiplier difference from 100 is " .. speedDiff);
	print("Actual additional rate is " .. multDiff);
	print("XCV Production Modifier Dummy quantities for +1,+10,+100,-1,-10 are" .. qtyDummyPlus1 .. "," .. qtyDummyPlus10 .. "," .. qtyDummyPlus100 .. "," .. qtyDummyMinus1 .. "," .. qtyDummyMinus10);
	print("Checking for Dummies against index " .. indexToCheck);
end


-- -----------------------------------------------------------------------------
-- Add dummy buildings to city center
function PlaceBuildingInCityCenter(pCity, iBuilding)
	local iCityPlotIndex = Map.GetPlot(pCity:GetX(), pCity:GetY()):GetIndex();
	pCity:GetBuildQueue():CreateIncompleteBuilding(iBuilding, iCityPlotIndex, 100);
	pCity:GetBuildings():SetPillaged(iBuilding, false);
end

function RepairAllDummiesInCity(pCity)
	print("Repairing XCV Production Modifier Dummies (whether needed or not).")
	pCity:GetBuildings():SetPillaged(dummyBuildingIndexPlus1, false);
	pCity:GetBuildings():SetPillaged(dummyBuildingIndexPlus10, false);
	pCity:GetBuildings():SetPillaged(dummyBuildingIndexPlus100, false);
	pCity:GetBuildings():SetPillaged(dummyBuildingIndexMinus1, false);
	pCity:GetBuildings():SetPillaged(dummyBuildingIndexMinus10, false);
end

function PlaceAllDummies(pCity)
	print("Placing XCV Production Modifier Dummies.")
	local dummyIndices = {dummyBuildingIndexPlus1, dummyBuildingIndexPlus10, dummyBuildingIndexPlus100, dummyBuildingIndexMinus1, dummyBuildingIndexMinus10};
	for i=1,5 do
		if (dummyQtys[i] > 0) then
			for k=1,dummyQtys[i] do
				PlaceBuildingInCityCenter(pCity, dummyIndices[i]);
			end
		end
	end
end

-- -----------------------------------------------------------------------------
function XCV_CityUpdate(PlayerID, CityID, CityX, CityY)
	dummyBuildingIndexPlus1 = GameInfo.Buildings["DUMMY_BUILDING_XCV_PROD_MULT_PLUS1"].Index;
	dummyBuildingIndexPlus10 = GameInfo.Buildings["DUMMY_BUILDING_XCV_PROD_MULT_PLUS10"].Index;
	dummyBuildingIndexPlus100 = GameInfo.Buildings["DUMMY_BUILDING_XCV_PROD_MULT_PLUS100"].Index;
	dummyBuildingIndexMinus1 = GameInfo.Buildings["DUMMY_BUILDING_XCV_PROD_MULT_MINUS1"].Index;
	dummyBuildingIndexMinus10 = GameInfo.Buildings["DUMMY_BUILDING_XCV_PROD_MULT_MINUS10"].Index;
	local dummyIndices = {dummyBuildingIndexPlus1, dummyBuildingIndexPlus10, dummyBuildingIndexPlus100, dummyBuildingIndexMinus1, dummyBuildingIndexMinus10};
	local pPlayer = Players[PlayerID];
	local pCity = pPlayer:GetCities():FindID(CityID);
	local sCity_LOC = pCity:GetName();
	print("Player # " .. PlayerID .. " has a city being updated with ID # " .. CityID .. ".");
	print("Building indices are as follows:");
	for m=1,5 do 
			print("#" .. m .. ": " .. dummyIndices[m]);
	end
	if (indexToCheck > 0) then
		if not pCity:GetBuildings():HasBuilding(dummyIndices[indexToCheck]) then
			PlaceAllDummies(pCity);
		else
			RepairAllDummiesInCity(pCity);
		end
	end
end

-- -----------------------------------------------------------------------------
function CityFinishedProduction(PlayerID, CityID, iCompletedItemType, iItemID)
	local pPlayer = Players[PlayerID];
	local pCity = pPlayer:GetCities():FindID(CityID);
	local sCity_LOC = pCity:GetName();
	--print("Player # " .. PlayerID .. " : city of " .. Locale.Lookup(sCity_LOC) .. " completed producing an item with ID " .. iItemID)
	local sCompletedItemName = "NONE";
	local sXCVPNotifier = "";
	if ( iCompletedItemType == 3 ) then
		--Type = "Project";
		if (GameInfo.Projects[ iItemID ] ~= nil) then
			sCompletedItemName = GameInfo.Projects[ iItemID ].Name;
			if (GameInfo.Projects[ iItemID ] == GameInfo.Projects["PROJECT_XCV_CULTURE_VICTORY_PROJECT1"]) then
				NotificationManager.SendNotification(playerID, "NOTIFICATION_PROJECT_FINISHED_XCV");
				print("Player # " .. PlayerID .. " completed culture victory project 1.");
			elseif (GameInfo.Projects[ iItemID ] == GameInfo.Projects["PROJECT_XCV_CULTURE_VICTORY_PROJECT2"]) then
				NotificationManager.SendNotification(playerID, "NOTIFICATION_PROJECT_FINISHED_XCV");
				print("Player # " .. PlayerID .. " completed culture victory project 2.");
			elseif (GameInfo.Projects[ iItemID ] == GameInfo.Projects["PROJECT_XCV_CULTURE_VICTORY_PROJECT3"]) then
				NotificationManager.SendNotification(playerID, "NOTIFICATION_PROJECT_FINISHED_XCV");
				print("Player # " .. PlayerID .. " completed culture victory project 3.");
			end
		end
		if ( sCompletedItemName == "NONE" ) then
			print("No valid data for the project completed could be found");
		end
	end
end

-- -----------------------------------------------------------------------------
function NotifyOthersOfProjectDone(PlayerID)
	local pids = GameConfiguration.GetParticipatingPlayerIDs();
	local szName = PlayerConfigurations[PlayerID]:GetCivilizationShortDescription();
	if (szName == nil or string.len(szName) == 0) then
		szName = PlayerConfigurations[PlayerID]:GetCivilizationTypeName();
	end
	local CivName = Locale.Lookup(szName);
	for _, pid in ipairs(pids) do 
		local pPlayer = Players[pid];
		local pDip = Players[PlayerID]:GetDiplomacy();
		if(pid ~= PlayerID) then
			if(pPlayer:IsAlive() and pPlayer:IsHuman()) then
				if(pDip:HasMet(pid)) then
					NotificationManager.SendNotification(pid, "NOTIFICATION_PROJECT_CREATED_BY_OTHER_XCV", CivName);
				else
					NotificationManager.SendNotification(pid, "NOTIFICATION_PROJECT_CREATED_BY_UNKNOWN_XCV");
				end
			end
		end
	end
end

-- -----------------------------------------------------------------------------
	
	--GameEvents.PlayerTurnStarted.Add(OnPlayerTurnActivated);
if XCV_ENABLED then
	Events.CityInitialized.Add(XCV_CityUpdate);
	Events.CityProductionCompleted.Add(CityFinishedProduction);
end
XCV_Initialize();

