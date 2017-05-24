
' Automidhandle needs to be true!

Type TBall
	
	Field posX:Float, posY:Float
	Field velX:Float = 0, velY:Float = 3
	Field radius:Float
	Field rotation:Float
	Field speed:Int
	Field image:TImage
	
	
	Function Create:TBall(img:TImage, px:Float, py:Float, r:Float = 16)
		Local b:TBall = New TBall
		b.posX = px
		b.posY = py
		b.radius = r
		b.image = img
		b.speed = 6
		Return b
	End Function
	
	
	Method UpdateCollisions(boardWidth:Int, boardHeight:Int, paddle:TPaddle, level:TLevel)
		' Collision with Board
		If Self.posX > boardWidth And Self.velX > 0
			Self.velX = Self.velX * -1.0
		End If
		If Self.posX < 0 And Self.velX < 0
			Self.velX = Self.velX * -1.0
		End If
		If Self.posY > boardHeight And Self.velY > 0
			Self.velY = Self.velY * -1.0
		End If
		If Self.posY < 0 And Self.velY < 0
			Self.velY = Self.velY * -1.0
		End If
		
		' Collision with Bat
		If Self.posX > paddle.GetPosX() - paddle.GetWidth()/2 And Self.posX < paddle.GetPosX() + paddle.GetWidth()/2 And Self.posY + Self.radius > paddle.GetPosY() And Self.posY + Self.radius < paddle.GetPosY() + paddle.GetHeight()
			Self.velX = ((Self.posX - paddle.GetPosX() ) / (paddle.GetWidth()/2) )
			If Abs(Self.velX) < 0.2 Then
				Self.velX = 0.2 * Sgn(Self.velX)
			End If
			If Abs(Self.velX) > 0.9 Then
				Self.velX = 0.9 * Sgn(Self.velX)
			End If
			
			Self.velY = - Sqr(1.0 - Self.velX * Self.velX)
			
			Self.velX = Self.velX * Self.speed
			Self.velY = Self.velY * Self.speed
		End If
		
		
		
		' Collision with Bricks
		For Local y:Int = 0 To level.Height - 1
			For Local x:Int = 0 To level.Width - 1
				If Not level.Tile[x, y] = 0
					Local deltaX:Float = Abs( Self.posX - x * TILEW )
					Local deltaY:Float = Abs( Self.posY - y * TILEH )
					
					If deltaX <= TILEW/2 + Self.radius And deltaY < TILEH/2
						Self.velX = Self.velX * -1.0
						level.Tile[x, y] = 0
					Else If deltaY <= TILEH/2 + Self.radius And deltaX < TILEW/2
						Self.velY = Self.velY * -1.0
						level.Tile[x, y] = 0
					End If
				End If
			Next
		Next
	End Method
	
	Method UpdateRotation()
		Self.rotation = Self.rotation + 10
		If Self.rotation >= 360 Then Self.rotation = 0
	End Method

	Method Update(boardWidth:Int, boardHeight:Int, paddle:TPaddle, level:TLevel)
		
		' Move the ball
		Self.posX = Self.posX + velX
		Self.posY = Self.posY + velY
		
		' Set balls rotation
		Self.UpdateRotation()
		
		Self.UpdateCollisions(boardWidth, boardHeight, paddle, level)
		
		' Did player miss the ball?
		If Self.posY > boardHeight Then

		End If
		
	End Method 
	
	Method Render()
		SetRotation Self.Rotation
		SetColor(0, 0, 0)
		SetAlpha(0.3)
		DrawImage(Self.image, Self.posX + 8, Self.posY + 8)
		SetColor(255, 255, 255)
		SetAlpha(1)
		DrawImage(Self.image, Self.posX, Self.posY)
		SetRotation 0
	End Method
	
	' Setter
	Method SetPosX(x:Float)
		Self.posX = x
	End Method 
	Method SetPosY(y:Float)
		Self.posY = y
	End Method 
	
	' Getter
	Method GetPosX:Float()
		Return Self.posX
	End Method 
	Method GetPosY:Float()
		Return Self.posY
	End Method 


End Type

