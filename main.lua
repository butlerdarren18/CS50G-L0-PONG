-- "Point" == "Nearest Neighbor"
-- Bilinear / Trilinear / Anistropic filtering cause bluriness in 2D

push = require 'push' -- this is how you add a library (remember to put it inside the project folder )
class = require 'class' -- classes exist in lua but the class library makes things simpler

-- Our Paddle class, stores pos and dimensions for each paddle + the logic for rendering them 
require 'Paddle'
require 'Ball'
WINDOW_WIDTH  = 1280
WINDOW_HEIGHT = 720 

PADDLE_SPEED = 200
-- PUSH ALLOWS FOR VIRTUAL RESOLUTION WINDOW 

VIRTUAL_WIDTH  = 432
VIRTUAL_HEIGHT = 243

function love.load()
	-- seed the rng with current time 
	math.randomseed(os.time())

	love.window.setTitle('CS50G - L0 - Pong in Love2D')

	gameFont = love.graphics.newFont('Font.ttf', 8)
	scoreFont = love.graphics.newFont('Font.ttf', 16)
	love.graphics.setFont(gameFont)

	player1Score = 0 
	player2Score = 0 

	player1 = Paddle(10, 30, 5, 20)
	player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
	ball = Ball(VIRTUAL_WIDTH / 2-2, VIRTUAL_HEIGHT / 2-2 , 4, 4)


	gameState = 'start'

	love.graphics.setDefaultFilter('nearest', 'nearest')

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, { 
		fullscreen = false,  -- remember your commas in your tables :| 
		resizable = false,
		vsync = true

	
	})
	
end


function love.update(delta)
	-- Player Movement

	player1:update(delta, 'w', 's')
	player2:update(delta, 'up', 'down')

	-- Ball Movement 
	if gameState == 'play' then 
		ball:update(delta)
	end

	--- PLAYER 1 BALL COLLISION
	if ball:collides(player1) then
		ball.dx = -ball.dx * 1.03 -- increase velocity by 3% 
		ball.x = player1.x + 5 -- make sure the ball isn't inside of the paddle 

		if ball.dy < 0 then 
			ball.dy = -math.random(50,150)
		else
			ball.dy = math.random(50,150)
		end 
	end


	--- PLAYER 2 BALL COLLISION 
	if ball:collides(player2) then 
		ball.dx = -ball.dx * 1.03 -- increase velocity by 3% 
		ball.x = player2.x -4 -- make sure the ball isn't inside of the paddle 

		if ball.dy < 0 then 
			ball.dy = -math.random(50,150)
		else
			ball.dy = math.random(50,150)
		end
	end

	-- UPPER AND LOWER BOUNDS
	if ball.y < 0 then
		ball.y = 0
		ball.dy = -ball.dy 
	end 

	if ball.y > VIRTUAL_HEIGHT then 
		ball.y = VIRTUAL_HEIGHT - 4
		ball.dy = -ball.dy 
	end 

	-- IF THE BALL REACHES THE EDGE OF THE SCREEN... 
	if ball.x < 0 then 
		servingPlayer = 1
		player2Score = player2Score + 1 
		ball:reset()
		gameState = 'serve'
	end

	if ball.x > VIRTUAL_WIDTH then 
		servingPlayer = 2
		player1Score = player1Score + 1
		ball:reset()
		gameState ='serve'
	end 
end 

-- if escape key is pressed then quit the program
function love.keypressed(key)
	if key == 'escape' then 
		love.event.quit()
	elseif key == 'enter'or  key == 'return' then 

		if gameState == 'serve' then 
			if servingPlayer == 1 then
				ball.dx = -25
			end
			if servingPlayer == 2 then
				ball.dx = 25
			end 
			gameState = 'play'

		elseif gameState == 'start' then 
			gameState = 'play'
		else
			if servingPlayer == 1 or servingPlayer == 2 then 
				gameState = 'serve'
			else
				gameState = 'start'
			end
			ball:reset()
		end 

	end

end 

function love.draw()

	push:apply('start')	-- anything in here runs inside of the virtual parameters from push 
	love.graphics.clear(40/255, 45/255, 52/255, 255) -- LOVE NOW USES RGB COLOR RANGE 0.0 - 1.0
	
	-- print HELLO PONG
	if gameState == 'start' then
		love.graphics.printf('HELLO PONG', 0,VIRTUAL_HEIGHT / 10, VIRTUAL_WIDTH, 'center')
	end 

	if gameState == 'serve' then 
		if servingPlayer == 1 then 
			love.graphics.printf('Player 1s turn to serve. \n Press enter to serve.', 0,VIRTUAL_HEIGHT / 10, VIRTUAL_WIDTH, 'center')
		elseif servingPlayer == 2 then
			love.graphics.printf('Player 2s turn to serve. \n Press enter to serve.', 0,VIRTUAL_HEIGHT / 10, VIRTUAL_WIDTH, 'center')
		end 
	end 
	
	-- render the paddles 
	player1:render()-- left 
	player2:render()-- right 

	-- render the ball 
	ball:render()

	-- switch font and draw score to right and left center of screen
	love.graphics.setFont(scoreFont)
	love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 40, VIRTUAL_HEIGHT / 3)
	love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
	displayFPS() 
	
	push:apply('end')

-- seeded random 
-- applied math.max( ) and math.min( ) to playerY values to keep the paddles on screen 
end
 
 function displayFPS()
 	love.graphics.setFont(love.graphics.newFont('Font.ttf', 8))
 	love.graphics.setColor(0, 255, 0, 255)
 	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10) -- lua does not allow string concatenation by default, 
end