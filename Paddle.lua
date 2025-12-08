
Paddle = class{}

function Paddle:init(x, y, width, height)
	self.width = width 
	self.height = height 
	self.x = x 
	self.y = y 
end 

function Paddle:update(delta)
	if love.keyboard.isDown('up') then 
		self.y = math.max(0,self.y + -PADDLE_SPEED * delta)
	elseif love.keyboard.isDown('down') then 
		self.y = math.min(VIRTUAL_HEIGHT - 20, self.y + PADDLE_SPEED * delta)