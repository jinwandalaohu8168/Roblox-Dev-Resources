local RunService = game:GetService("RunService")

local SpriteSheetPlayer = {}
SpriteSheetPlayer.__index = SpriteSheetPlayer

function SpriteSheetPlayer.new(imageLabel, sheetSize, columns, rows, fps)
	local self = setmetatable({}, SpriteSheetPlayer)

	self.ImageLabel = imageLabel
	self.Columns = columns
	self.Rows = rows
	self.FrameCount = columns * rows
	self.FPS = fps or 30

	self.FrameSize = Vector2.new(
		sheetSize.X / columns,
		sheetSize.Y / rows
	)

	self.Frame = 1
	self.Time = 0
	self.Connection = nil

	imageLabel.ImageRectSize = self.FrameSize

	return self
end

function SpriteSheetPlayer:setFrame(frame)
	self.Frame = frame

	local index = frame - 1
	local x = index % self.Columns
	local y = math.floor(index / self.Columns)

	self.ImageLabel.ImageRectOffset = Vector2.new(
		x * self.FrameSize.X,
		y * self.FrameSize.Y
	)
end

function SpriteSheetPlayer:play()
	if self.Connection then
		return
	end

	self.Connection = RunService.Heartbeat:Connect(function(dt)
		self.Time += dt

		if self.Time >= 1 / self.FPS then
			self.Time = 0

			self.Frame += 1
			if self.Frame > self.FrameCount then
				self.Frame = 1
			end

			self:setFrame(self.Frame)
		end
	end)
end

function SpriteSheetPlayer:stop()
	if self.Connection then
		self.Connection:Disconnect()
		self.Connection = nil
	end
end

return SpriteSheetPlayer


-- =====================================
local SpriteSheetPlayer = require(path.SpriteSheetPlayer)

local player = SpriteSheetPlayer.new(
	script.Parent.ImageLabel,
	Vector2.new(1024, 1024),
	4,
	4,
	30
)

player:play()