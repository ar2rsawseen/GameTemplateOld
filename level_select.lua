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
level_select = gideros.class(Sprite)

function level_select:init()
	--load highscores
	local highScore = dataSaver.loadValue("scores")
	if(not highScore) then
		highScore = {}
	end
	
	--back button
	local backButton = Button.new(Bitmap.new(Texture.new("images/back_up.png")), Bitmap.new(Texture.new("images/back_down.png")))
	backButton:setPosition((application:getContentWidth()-backButton:getWidth())/2, application:getContentHeight()-backButton:getHeight())
	self:addChild(backButton)

	backButton:addEventListener("click", 
		function()	
			sceneManager:changeScene("pack_select", 1, transition, easing.outBack) 
		end
	)
	
	--level select image sizes
	local boxWidth = 90
	local boxHeight = 90
	--start and increment positions
	--five columns
	local stepWidth = (application:getContentWidth() - boxWidth*5)/6
	--four rows
	local stepHeight = ((application:getContentHeight()-backButton:getHeight()) - boxHeight*4)/6
	local startX = stepWidth
	local startY = stepHeight
	local cnt = 0
	--generate all levels in pack
	for i = 1, packs.packs[sets.curPack].levels, 1 do 
		
		--check highscores for this level
		if(not highScore[(sets.curPack).."-"..i]) then
			highScore[(sets.curPack).."-"..i] = {}
			highScore[(sets.curPack).."-"..i].score = 0
		end
		
		--create group
		local group = Sprite.new()
		
		--create level image
		local box
		--check if unlocked or first
		if(highScore[(sets.curPack).."-"..i].unlocked or i == 1) then
			box = Button.new(Bitmap.new(Texture.new("images/crate.png")), Bitmap.new(Texture.new("images/crate.png")))
			--level number
			box.cnt = i
		
			--add event listener
			box:addEventListener("click", function(e)
				--get target of event
				local target = e.__target
				--get selected level
				sets.curLevel = target.cnt
				--save current level
				dataSaver.saveValue("sets", sets)
				--stop propagation
				e:stopPropagation()
				--go to selected level
				showDescription = true
				if showDescription then
					--create level description
					self.description = Shape.new()
					self.description:setFillStyle(Shape.SOLID, 0xff0000, 0.5)   
					self.description:beginPath(Shape.NON_ZERO)
					self.description:moveTo(application:getContentWidth()/5,application:getContentHeight()/16)
					self.description:lineTo((application:getContentWidth()/5)*4, application:getContentHeight()/16)
					self.description:lineTo((application:getContentWidth()/5)*4, application:getContentHeight()-(application:getContentHeight()/16))
					self.description:lineTo(application:getContentWidth()/5, application:getContentHeight()-(application:getContentHeight()/16))
					self.description:lineTo(application:getContentWidth()/5, application:getContentHeight()/16)
					self.description:endPath()
					self:addChild(self.description)
					
					self.description:addEventListener(Event.MOUSE_DOWN, function()
						sceneManager:changeScene("level", 1, transition, easing.outBack)
					end)
					
					--setting up description texts
					local lastHeight = (application:getContentHeight()/16)*2
					local textWidth = ((application:getContentWidth()/5)*3) - ((application:getContentHeight()/16)*2)
					local levelName = TextWrap.new("Level Name "..sets.curLevel.." - simply click to start", textWidth)
					levelName:setPosition((application:getContentWidth()/5)+application:getContentHeight()/16, lastHeight)
					levelName:setTextColor(0xffffff)
					self.description:addChild(levelName)
					lastHeight = lastHeight + 20 + levelName:getHeight()
					
					local levelDesc = TextWrap.new("Click more to make crate jump. Description: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc suscipit arcu placerat lorem iaculis bibendum. Phasellus eu urna non massa rutrum euismod. Proin ac scelerisque augue. Sed vitae augue mi. Cras mi tellus, auctor pulvinar aliquet sed, suscipit eget justo. Nulla nec sem ac metus mollis ullamcorper eget eget dolor. Phasellus dapibus ligula ut lectus fringilla eu suscipit purus iaculis. Pellentesque commodo ipsum ac magna sollicitudin placerat. Morbi tempor pellentesque lacinia. Praesent quis mauris diam. Proin scelerisque venenatis libero, eu dictum orci placerat eget. In vitae metus quis ligula mollis blandit. Vestibulum est sem, ultricies id tempus et, sollicitudin eu augue.", textWidth, "justify")
					levelDesc:setPosition((application:getContentWidth()/5)+application:getContentHeight()/16, lastHeight)
					levelDesc:setTextColor(0xffffff)
					self.description:addChild(levelDesc)
				else
					sceneManager:changeScene("level", 1, transition, easing.outBack)
				end
			end)
		else
			box = Button.new(Bitmap.new(Texture.new("images/crate_locked.png")), Bitmap.new(Texture.new("images/crate_locked.png")))
		end
		
		--scaling to provided size
		box.upState:setScaleX(boxWidth/box.upState:getWidth())
		box.upState:setScaleY(boxHeight/box.upState:getHeight())
		box.downState:setScaleX(boxWidth/box.downState:getWidth())
		box.downState:setScaleY(boxHeight/box.downState:getHeight())
		box:setPosition(startX,startY)
		
		group:addChild(box)
		
		local levelName = TextField.new(nil, "Level: "..i)
		levelName:setPosition(startX,startY+20)
		levelName:setTextColor(0xffffff)
		group:addChild(levelName)
		
		local score = TextField.new(nil, "Score: "..highScore[(sets.curPack).."-"..i].score)
		score:setPosition(startX,startY+30)
		score:setTextColor(0xffffff)
		group:addChild(score)
		
		--split levels in rows by 5 columns
		if cnt == 4 then 
			cnt = 0
			startX = stepWidth
			startY = startY + box:getHeight() + stepHeight
		else
			startX = startX + box:getWidth() + stepWidth
			cnt = cnt + 1
		end
		
		self:addChild(group)
	end
	
end