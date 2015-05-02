-- #NoSimplerr#
local hideHUDElements = {
	["DarkRP_HUD"] = true,
	["DarkRP_EntityDisplay"] = false,
	["DarkRP_ZombieInfo"] = false,
	["DarkRP_LocalPlayerHUD"] = false,
	["DarkRP_Hungermod"] = false,
	["DarkRP_Agenda"] = false,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
}

hook.Add("HUDShouldDraw", "HideDefaultDarkRPHud", function(name)
	if hideHUDElements[name] then return false end
end)

surface.CreateFont( "bHUD_22", {
font = "Roboto Lt",
size = 22,
weight = 500,
antialias = true,
} )
surface.CreateFont( "bHUD_18", {
font = "Roboto Lt",
size = 18,
weight = 500,
antialias = true,
} )
--// config
local bHUD_Hunger = false
local bHUD_Sprint = false

--// locals
local Health = 0
local Armor = 0
local Sprint = 0
local Hunger = 0
local LP = LocalPlayer()
local x, y = 20, ScrH() - 20

--// icons Text
local icon_ammo = Material("bhud/ammo.png", "noclamp smooth")
local icon_atm = Material("bhud/atm.png", "noclamp smooth")
local icon_salary = Material("bhud/salary.png", "noclamp smooth")
local icon_info = Material("bhud/info.png", "noclamp smooth")
local icon_job = Material("bhud/job.png", "noclamp smooth")
local icon_wallet = Material("bhud/wallet.png", "noclamp smooth")
local icon_gun1 = Material("bhud/gun1.png", "noclamp smooth")
local icon_gun2 = Material("bhud/gun2.png", "noclamp smooth")
--// icons Bar
local icon_armor = Material("bhud/armor.png", "noclamp smooth")
local icon_health = Material("bhud/health.png", "noclamp smooth")
local icon_hunger = Material("bhud/hunger.png", "noclamp smooth")
local icon_sprint = Material("bhud/sprint.png", "noclamp smooth")

--// maths
local forth = 120 + 30 + 15 + 30 + 15 + 30 + 15
local third = 120 + 30 + 15 + 30 + 15
local second = 120 + 30 + 15
local first = 120

local healthOffset = forth
local armoroffset = third
local sprintOffset = second
local hungerOffset = first

local function getAmmo()
	local weap = LP:GetActiveWeapon()
	if weap:GetClass() == 'weapon_physgun' or weap:GetClass() == 'weapon_physcannon' then return "" end
	if not weap or not LP:Alive() then return 0 end
	local ammo_inv = weap:Ammo1() or 0
	local ammo_clip = weap:Clip1() or 0
	if ammo_clip == -1 then
	return ""
	else
	return ammo_clip .. " | " .. ammo_inv
	end
end

local function Base()
	draw.RoundedBox(0, x, y - 180, 310, 180, Color(191,191,191))
	draw.RoundedBox(0, x, y - 180 + 1, 310, 30, Color(236,236,236))
	draw.RoundedBox(0, x, y - 150, 310, 1, Color(127,127,127))
end
local function drawTextInfo()
	--// Nickname
	draw.SimpleText(LP:Nick(), "bHUD_22", x + 10 + 20,y - 180 + 4, Color(0,0,0),  TEXT_ALIGN_LEFT , TEXT_ALIGN_LEFT )
	
	--// DarkRP
	local dosh = DarkRP.formatMoney(LP:getDarkRPVar( "money" ) or 0)
	draw.SimpleText(dosh, "bHUD_18", x + 10 + 20, y - 130, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	local salary = DarkRP.formatMoney(LP:getDarkRPVar( "salary" ) or 0)
	draw.SimpleText(salary, "bHUD_18", x + 10 + 20, y - 100, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	local job = LP:getDarkRPVar( "job" ) or ""
	draw.SimpleText(job, "bHUD_18", x + 10 + 20, y - 70, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	local ammo = getAmmo()
	draw.SimpleText(ammo, "bHUD_18", x + 10 + 20, y - 40, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
end

local function drawIconInfo()
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial(icon_info)
	surface.DrawTexturedRect(x + 7, y - 180 + 6, 16, 16)
	surface.SetMaterial(icon_wallet)
	surface.DrawTexturedRect(x + 7, y - 130 - 1, 16, 16)
	surface.SetMaterial(icon_salary)
	surface.DrawTexturedRect(x + 7, y - 100 - 1, 16, 16)
	surface.SetMaterial(icon_job)
	surface.DrawTexturedRect(x + 7, y - 70 - 1, 16, 16)
	local ammo = getAmmo()
	if ammo == "" then return end
	surface.SetMaterial(icon_ammo)
	surface.DrawTexturedRect(x + 7, y - 40 - 1, 16, 16)
end
local function drawLicense()
	surface.SetDrawColor(255,255,255,255)
	if LP:getDarkRPVar( "HasGunlicense" ) then
	surface.SetMaterial(icon_gun1)
	else
	surface.SetMaterial(icon_gun2)
	end
	surface.DrawTexturedRect(x + 290 - 7, y - 180 + 6, 16, 16)
end
local function drawHealth()
	Health = math.min(100, (Health == LP:Health() and Health) or Lerp(0.1, Health, LP:Health()))
	local yoffset = 130
	--// Outlined Rect
	draw.RoundedBox(0, x + healthOffset, y - yoffset, 30, 1, Color(0,0,0)) --top
	draw.RoundedBox(0, x + healthOffset, y - yoffset, 1, 101, Color(0,0,0)) --left
	draw.RoundedBox(0, x + healthOffset, y - 29, 30, 1, Color(0,0,0))
	draw.RoundedBox(0, x + healthOffset + 30, y - yoffset, 1, 102, Color(0,0,0))
	--// Healthbar
	draw.RoundedBox(0, x + healthOffset + 1, y - 29 - Health, 29, Health, Color(231,76,60))
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial(icon_health)
	surface.DrawTexturedRect(x + healthOffset + 7, y - 29 - 20, 16, 16)
end
local function drawArmor()
	if LP:Armor() == 0 then return end
	Armor = math.min(100, (Armor == LP:Armor() and Armor) or Lerp(0.1, Armor, LP:Armor()))
	local yoffset = 130
	--// Outlined Rect
	draw.RoundedBox(0, x + armoroffset, y - yoffset, 30, 1, Color(0,0,0)) --top
	draw.RoundedBox(0, x + armoroffset, y - yoffset, 1, 101, Color(0,0,0)) --left
	draw.RoundedBox(0, x + armoroffset, y - 29, 30, 1, Color(0,0,0))
	draw.RoundedBox(0, x + armoroffset + 30, y - yoffset, 1, 102, Color(0,0,0))
	--// Armor Bar
	draw.RoundedBox(0, x + armoroffset + 1, y - 29 - Armor, 29, Armor, Color(89,171,227))
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial(icon_armor)
	surface.DrawTexturedRect(x + armoroffset + 7, y - 29 - 20, 16, 16)
end
local function drawSprint()
	if !bHUD_Sprint then return end
	Sprint = math.min(100, (Sprint == LP:GetNWInt( "tcb_stamina") and Sprint) or Lerp(0.1, Sprint, LP:GetNWInt( "tcb_stamina")))
	local yoffset = 130
	--// Outlined Rect
	draw.RoundedBox(0, x + sprintOffset, y - yoffset, 30, 1, Color(0,0,0)) --top
	draw.RoundedBox(0, x + sprintOffset, y - yoffset, 1, 101, Color(0,0,0)) --left
	draw.RoundedBox(0, x + sprintOffset, y - 29, 30, 1, Color(0,0,0))
	draw.RoundedBox(0, x + sprintOffset + 30, y - yoffset, 1, 102, Color(0,0,0))
	--// SprintBar
	draw.RoundedBox(0, x + sprintOffset + 1, y - 29 - Sprint, 29, Sprint, Color(244,215,110))
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial(icon_sprint)
	surface.DrawTexturedRect(x + sprintOffset + 7, y - 29 - 20, 16, 16)
end
local function drawHunger()
	if !bHUD_Hunger then return end
	Hunger = math.min(100, (Hunger == LP:getDarkRPVar( "Energy" ) and Hunger) or Lerp(0.1, Hunger, LP:getDarkRPVar( "Energy" )))
	local yoffset = 130
	--// Outlined Rect
	draw.RoundedBox(0, x + hungerOffset, y - yoffset, 30, 1, Color(0,0,0)) --top
	draw.RoundedBox(0, x + hungerOffset, y - yoffset, 1, 101, Color(0,0,0)) --left
	draw.RoundedBox(0, x + hungerOffset, y - 29, 30, 1, Color(0,0,0))
	draw.RoundedBox(0, x + hungerOffset + 30, y - yoffset, 1, 102, Color(0,0,0))
	--// Healthbar
	draw.RoundedBox(0, x + hungerOffset + 1, y - 29 - Hunger, 29, Hunger, Color(200,247,197))
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial(icon_hunger)
	surface.DrawTexturedRect(x + hungerOffset + 7, y - 29 - 20, 16, 16)
end

local function hudPaint()
	Base()
	drawTextInfo()
	drawIconInfo()
	drawLicense()
	drawHealth()
	drawArmor()
	drawSprint()
	drawHunger()
end

hook.Add("HUDPaint", "DarkRP_Mod_HUDPaint", hudPaint)
