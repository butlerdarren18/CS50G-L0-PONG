
Paddle = class{}

function Paddle:init(x, y, width, height)
	self.width = width 
	self.height = height 
	self.x = x 
	self.y = y 
end 

function Paddle:update(delta, up_key, down_key)
	if love.keyboard.isDown(up_key) then 
		self.y = math.max(0,self.y + -PADDLE_SPEED * delta)
	elseif love.keyboard.isDown(down_key) then 
		self.y = math.min(VIRTUAL_HEIGHT - 20, self.y + PADDLE_SPEED * delta)
	end 
end 

function Paddle:render()
	love.graphics.rectangle('fill',self.x, self.y, self.width, self.height)
end 