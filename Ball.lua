
Ball = class{}

function Ball:init(x, y, width, height)
	self.x = x
	self.y = y 
	self.width = width 
	self.height = height 

	-- for velocity 
	self.dy = math.random(2) == 1 and -BALL_SPEED or BALL_SPEED
	self.dx = math.random(-BALL_SPEED, BALL_SPEED)
end 

function Ball:reset()
	self.x = VIRTUAL_WIDTH / 2-2 
	self.y = VIRTUAL_HEIGHT / 2-2 
	self.dy = math.random(2) == 1 and BALL_SPEED or -BALL_SPEED
	self.dx = math.random(-BALL_SPEED/2, BALL_SPEED/2)
end

function Ball:update(dt)
	-- move the ball 
	self.x = self.x + self.dx * dt 
	self.y = self.y + self.dy * dt 



end

function Ball:render()
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Ball:collides(paddle)
	-- if the left edge is farther to the right than the right edge of the other 
	if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then 
		return false 
	end 
	-- then top bottom 
	if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then 
		return false
	end

	-- if the above aren't true, they are overlapping 
	return true 
end 