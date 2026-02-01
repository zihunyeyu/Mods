print('loading UnitPromotionPopup_TKH')


include("UnitPromotionPopup.lua")

local SIZE_NODE_X                         = 150;             -- Item node dimensions
local SIZE_NODE_Y                         = 146;
local SIZE_NODE_X_HALF                    = SIZE_NODE_X / 2; -- Item node dimensions
local SIZE_NODE_Y_HALF                    = SIZE_NODE_Y / 2;
local SIZE_PATH                           = 40;
local SIZE_PATH_HALF                      = 20;
local SIZE_ROW_Y                          = 106;
local SIZE_COLUMN_X                       = 212;
local LINE_BEFORE_CURVE                   = 20; -- MIN-MAX 40-(SIZE_NODE_Y/3)

local MAX_WIDTH                           = 1024;
local MAX_HEIGHT                          = 768;

local WIDTH_PADDING                       = 50;
local HEIGHT_PADDING                      = 120;

local TKH_OnPromotionContainerSizeChanged = OnPromotionContainerSizeChanged

function OnPromotionContainerSizeChanged()
	local desiredWidth = Controls.PromotionContainer:GetSizeX() + WIDTH_PADDING;
	if desiredWidth > MAX_WIDTH then
		desiredWidth = MAX_WIDTH;
	end


	local desiredHeight = Controls.PromotionContainer:GetSizeY() + HEIGHT_PADDING;

	-- print('desiredHeight = ', desiredHeight, MAX_HEIGHT)
	-- if desiredHeight > MAX_HEIGHT then
	-- 	desiredHeight = MAX_HEIGHT;
	-- 	UI.DataError("Unit promotion tree height exceeds maximum panel height.");
	-- end


	Controls.PopupFrameGrid:SetSizeX(desiredWidth);
	Controls.PopupFrameGrid:SetSizeY(desiredHeight);
end
