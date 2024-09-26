-- alt + l runs in love2d
-- 关闭lua诊断以关闭命名检查的波浪线

G = require("globals")

function love.load()
    -- main table for whole project
	love.window.setTitle("target game")

	music = love.audio.newSource("sound/mus.wav", "stream")
	music:setLooping(true)
	music:play()

    target = {
        x = 100,
        y = 100,
        radius = 50
    }

    score = 0
    timer = 0

    gameFont = love.graphics.newFont(40)

    sprites = {}
    sprites.sky = love.graphics.newImage("sprites/sky.png")
    sprites.target = love.graphics.newImage("sprites/target.png")
    sprites.crosshair = love.graphics.newImage("sprites/crosshair.png")

	-- hide the mouse
	love.mouse.setVisible(false)

	gameState = "start"

end

function love.update(dt)    -- delta time
    if timer > 0 and gameState == "playing" then
        timer = timer - dt
	elseif timer <= 0 then
        timer = 0
    end
end

function love.draw()
	local windowWidth, windowHeight = love.graphics.getDimensions()
	-- the background picture is too small to fill the main window
	-- so it adjusted
	love.graphics.draw(sprites.sky, 0, 0, 0, windowWidth / sprites.sky:getWidth(), windowHeight / sprites.sky:getHeight())

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(gameFont)

	if gameState == "start" then
		love.graphics.printf("Click anywhere to begin!", 0, 250, love.graphics.getWidth(), "center")
	elseif gameState == "playing" and timer == 0 then
		gameState = "gameEnd"
		love.graphics.printf("Your score is " .. score, 0, 250, love.graphics.getWidth(), "center")
	end

    -- love.graphics.setColor(1, 0, 0)
    -- love.graphics.circle("fill", target.x, target.y, target.radius)

	love.graphics.setColor(1, 1, 1)
	local targetWidth = sprites.target:getWidth()
	local targetHeight = sprites.target:getHeight()
	-- only draw the target while the game is running
	if gameState == "playing" and timer ~= 0 then
		love.graphics.draw(
			sprites.target,
			target.x - targetWidth / 2,
			target.y - targetHeight / 2
		)
	end

	-- chinese not supported...
	love.graphics.print("Score: " .. score, 0, 0)
	love.graphics.print("Time: " .. math.ceil(timer), 300, 0)

    local crosshairWidth = sprites.crosshair:getWidth()
    local crosshairHeight = sprites.crosshair:getHeight()
	-- put crosshair in the cursor center
	love.graphics.draw(
		sprites.crosshair,
		love.mouse.getX() - crosshairWidth / 2,
		love.mouse.getY() - crosshairHeight / 2
	)

end

function love.mousepressed( x, y, button, istouch, presses )
    -- check the left click and increase the score
    if button == 1 and gameState == "playing" and timer ~= 0 then
        mouseToTarget = distanceBetween(x, y, target.x, target.y)
		-- clicked in the target
        if mouseToTarget < target.radius then
            score = score + 1
			local music = love.audio.newSource("sound/clickedTarget.mp3", "stream")
			-- music:setLooping(true)
			music:play()
            -- random position and make sure the whole circle in the window
            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
            target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
        end
	elseif button == 1 then
		gameState = "playing"
		timer = 10
		score = 0
	end
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function love.keypressed(key)
	if key == "escape" then
		menu()
	elseif key == "r" then
		-- reload the game
		love.load()
	end
end

function menu()
	gameState = "menu"
	-- 毛玻璃
	-- 加入一个擦唱片的暂停音效同时音乐暂停
end