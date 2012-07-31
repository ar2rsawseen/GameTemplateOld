--[[
*************************************************************
 * This script is developed by Arturs Sosins aka ar2rsawseen, http://appcodingeasy.com
 * Feel free to distribute and modify code, but keep reference to its creator
 *
 * Gideros Game Template for developing games. Includes: 
 * Start scene, pack select, level select, settings, score system and much more
 *
 * For more information, examples and online documentation visit: 
 * http://appcodingeasy.com/Gideros-Mobile/Gideros-Mobile-Game-Template
**************************************************************
]]--

options = gideros.class(Sprite)

function options:init()
	--here we'd probably want to set up a background picture
	local screen = Bitmap.new(Texture.new("images/gideros_mobile.png"))
	self:addChild(screen)
	screen:setPosition((application:getContentWidth()-screen:getWidth())/2, (application:getContentHeight()-screen:getHeight())/2)
	
	--create layer for menu buttons
	local menu = Shape.new()
	menu:setFillStyle(Shape.SOLID, 0xffffff, 0.5)   
	menu:beginPath(Shape.NON_ZERO)
	menu:moveTo(application:getContentWidth()/5,application:getContentHeight()/16)
	menu:lineTo((application:getContentWidth()/5)*4, application:getContentHeight()/16)
	menu:lineTo((application:getContentWidth()/5)*4, application:getContentHeight()-(application:getContentHeight()/16))
	menu:lineTo(application:getContentWidth()/5, application:getContentHeight()-(application:getContentHeight()/16))
	menu:lineTo(application:getContentWidth()/5, application:getContentHeight()/16)
	menu:endPath()
	self:addChild(menu)

	local musicOnButton = menuButton("images/musicon_up.png","images/musicon_down.png", menu, 1,3)
	local musicOffButton = menuButton("images/musicoff_up.png","images/musicoff_down.png", menu, 1,3)
	musicOnButton:addEventListener("click", 
		function()
			menu:removeChild(musicOnButton)
			music.off()
			menu:addChild(musicOffButton)
		end
	)

	musicOffButton:addEventListener("click", 
		function()
			menu:removeChild(musicOffButton)
			music.on()
			menu:addChild(musicOnButton)
		end
	)
	
	if sets.music then
		menu:addChild(musicOnButton)
	else
		menu:addChild(musicOffButton)
	end
	
	local soundsOnButton = menuButton("images/soundson_up.png","images/soundson_down.png", menu, 2,3)
	local soundsOffButton = menuButton("images/soundsoff_up.png","images/soundsoff_down.png", menu, 2,3)
	
	soundsOnButton:addEventListener("click", 
		function()
			menu:removeChild(soundsOnButton)
			menu:addChild(soundsOffButton)
			sounds.off()
		end
	)
	
	soundsOffButton:addEventListener("click", 
		function()
			menu:removeChild(soundsOffButton)
			menu:addChild(soundsOnButton)
			sounds.on()
		end
	)
	
	if sets.sounds then
		menu:addChild(soundsOnButton)
	else
		menu:addChild(soundsOffButton)
	end
	
	local backButton = menuButton("images/back_up.png","images/back_down.png", menu, 3,3)
	menu:addChild(backButton)
	backButton:addEventListener("click", 
		function()	
			sceneManager:changeScene("start", 1, transition, easing.outBack) 
		end
	)
	
	
end