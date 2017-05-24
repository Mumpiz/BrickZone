
' Automidhandle needs to be true!

Type TPaddle

	Field posX:Float, posY:Float
	Field width:Int, height:Int
	Field image:TImage
		
	Function Create:TPaddle(x:Float, y:Float, img:TImage)
		Local p:TPaddle = New TPaddle
		p.width = ImageWidth(img)
		p.height = ImageHeight(img)
		p.posX = x
		p.posY = y
		p.image = img
		Return p
	End Function 
	
	Method Update()
		Self.posX = MouseX()
	End Method
	
	Method Render()
		SetColor(0, 0, 0)
		SetAlpha(0.3)
		DrawImage(Self.image, Self.posX + 8, Self.posY + 8)
		SetColor(255, 255, 255)
		SetAlpha(1)
		DrawImage(Self.image, Self.posX, Self.posY)			
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
	Method GetWidth:Int()
		Return Self.width
	End Method 
	Method GetHeight:Int()
		Return Self.height
	End Method 

End Type

