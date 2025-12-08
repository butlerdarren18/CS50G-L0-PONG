-- "Point" == "Nearest Neighbor"
-- Bilinear / Trilinear / Anistropic filtering cause bluriness in 2D

push = require 'push' -- this is how you add a library (remember to put it inside the project folder )
class = require 'class' -- classes exist in lua but the class library makes things simpler

-- Our Paddle class, stores pos and dimensions for each paddle + the logic for rendering them 
require 'Paddle'
WINDOW_WIDTH  = 1280
WINDOW_HEIGHT = 720 

PADDLE_SPEED = 200
-- PUSH ALLOWS FOR VIRTUAL RESOLUTION WINDOW 

VIRTUAL_WIDTH  = 432
VIRTUAL_HEIGHT = 243

function love.load()
	-- seed the rng with current time 
	math.randomseed(os.time())

	gameFont = love.graphics.newFont('Font.ttf', 8)
	scoreFont = love.graphics.newFont('Font.ttf', 16)
	love.graphics.setFont(gameFont)

	player1Score = 0 
	player2Score = 0 

	player1Y = 30
	player2Y = VIRTUAL_HEIGHT - 50

	ballX = VIRTUAL_WIDTH / 2 - 2 
	ballY = VIRTUAL_HEIGHT / 2 - 2

	ballDX  = math.random(2) == 1 and 100 or -100 
	ballDY = math.random(-50, 50)
	gameState = 'start'

	love.graphics.setDefaultFilter('nearest', 'nearest')

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, { 
		fullscreen = false,  -- remember your commas in your tables :| 
		resizable = false,
		vsync = true

	
	})
	
end


function love.update(delta)

	-- PLAYER 1 MOVEMENT
	if love.keyboard.isDown('w') then 
		player1Y = math.max(0, player1Y + -PADDLE_SPEED * delta) 
	elseif love.keyboard.isDown('s') then
		player1Y = math.min(VIRTUAL_HEIGHT -20, player1Y + PADDLE_SPEED * delta )

	end 

	-- PLAYER 2 MOVEMENT 
	if love.keyboard.isDown('up') then 
		player2Y = math.max(0,player2Y + -PADDLE_SPEED * delta)
	elseif love.keyboard.isDown('down') then 
		player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * delta)
	end
	
	-- BALL 
	if gameState == 'play' then 
		ballX = ballX + ballDX * delta 
		ballY = ballY + ballDY * delta 
	end 


end 

-- if escape key is pressed then quit the program
function love.keypressed(key)
	if key == 'escape' then 
		love.event.quit()
	elseif key == 'enter'or  key == 'return' then 
		if gameState == 'start' then 
			gameState = 'play'
		else
			gameState = 'start'
			-- Set ball back to center 
			ballX = VIRTUAL_WIDTH / 2 - 2 
			ballY = VIRTUAL_HEIGHT / 2 - 2 

			-- ternary operation --- if 1 then 100 and if not 1 then -100 
			ballDX = math.random(2) == 1 and 100 or -100 
			ballDY = math.random(-50, 50) * 1.5
		end 

	end

end 

function love.draw()

	push:apply('start')	-- anything in here runs inside of the virtual parameters from push 
	love.graphics.clear(40/255, 45/255, 52/255, 255) -- LOVE NOW USES RGB COLOR RANGE 0.0 - 1.0
	
	-- print HELLO PONG
	love.graphics.printf('HELLO PONG', 0,VIRTUAL_HEIGHT / 10, VIRTUAL_WIDTH, 'center')
	
	-- render the paddles 
	love.graphics.rectangle('fill', 10, player1Y, 5, 20) -- left 
	love.graphics.rectangle('fill',VIRTUAL_WIDTH-10,player2Y, 5, 20) -- right 

	-- render the ball 
	love.graphics.rectangle('fill', ballX, ballY, 4,4)

	-- switch font and draw score to right and left center of screen
	love.graphics.setFont(scoreFont)
	love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
	love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3) 
	
	push:apply('end')

-- seeded random 
-- applied math.max( ) and math.min( ) to playerY values to keep the paddles on screen 
end
 