--variables
local gameState = "Menu"
local menuButtons = {}
local windowWidth = love.graphics.getWidth()
local windowHeight = love.graphics.getHeight()

--functions
local newMenuButton
local drawMenu
local drawGame
local distanceBetween

function love.load()
	buyButton = {}
	buyButton.x = 200
	buyButton.y = 200
	buyButton.size = 50
	
	score = 0
	timer = 0
	
	gameFont = love.graphics.newFont(40)
	menuFont = love.graphics.newFont(32)
	
	table.insert(menuButtons, newMenuButton("Start Game", function() gameState = "Game" end))
	table.insert(menuButtons, newMenuButton("Settings", function() print("go to settings menu") end))
	table.insert(menuButtons, newMenuButton("Exit", function() love.event.quit(0) end))
end

function love.update(dt)
	
end

function love.draw()
	if gameState == "Menu" then
		drawMenu()
	elseif gameState == "Game" then
		drawGame()
	end
end

function newMenuButton(text, func)
	return {
		text = text,
		func = func,
		curState = false,
		lastState = false
	}
end

function drawMenu()
	local buttonWidth = windowWidth / 3
	local buttonHeight = buttonWidth / 5
	local margin = 15
	local totalHeight = (buttonHeight + margin) * #menuButtons
	local cursorY = 0
	
	local defaultColor = {0.4, 0.4, 0.5}
	local highlightColor = {0.8, 0.8, 0.9}
	
	for i, bt in ipairs(menuButtons) do
		bt.lastState = bt.curState
		bt.curState = love.mouse.isDown(1)
		
		local buttonX = (windowWidth - buttonWidth) / 2 
		local buttonY = (windowHeight - totalHeight) / 2 + cursorY
		
		if love.mouse.getX() > buttonX and love.mouse.getX() < buttonX + buttonWidth and love.mouse.getY() > buttonY and love.mouse.getY() < buttonY + buttonHeight then
			love.graphics.setColor(unpack(highlightColor))
			if bt.curState and not bt.lastState then
				bt.func()
			end
		else
			love.graphics.setColor(unpack(defaultColor))
		end
		love.graphics.rectangle("fill", buttonX, buttonY, buttonWidth, buttonHeight)
		
		love.graphics.setColor(0, 0, 0)
		love.graphics.print(bt.text, menuFont, (windowWidth - menuFont:getWidth(bt.text)) / 2, buttonY + menuFont:getHeight(bt.text) / 4)
		
		cursorY = cursorY + buttonHeight + margin
	end
end

function drawGame()
	love.graphics.setColor(1, 0, 0)
	love.graphics.circle("fill", buyButton.x, buyButton.y, buyButton.size)
		
	love.graphics.setColor(1, 1, 1)
	love.graphics.setFont(gameFont)
	love.graphics.print(score)
end

function love.mousepressed(x, y, button, isTouch)
	if button == 1 then
		if gameState == "Game" and distanceBetween(buyButton.x, buyButton.y, love.mouse.getX(), love.mouse.getY()) < buyButton.size then
			score = score + 1
			buyButton.x = math.random(buyButton.size, windowWidth - buyButton.size)
			buyButton.y = math.random(buyButton.size, windowHeight - buyButton.size)
		end
	end
end

function distanceBetween(x1, y1, x2, y2)
	return math.sqrt((y2 - y1)^2 + (x2 - x1)^2)
end