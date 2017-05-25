

' Automidhandle needs to be true!


Const GWIDTH:Int = 800, GHeight:Int = 600
Const TILEW:Int = 40, TILEH:Int = 40, NTILES:Int = 20



Type TLevel
	Global Width:Int = 20, Height:Int = 10
	
	Field PathBgi:String 'Path to Background Image file
	Field PathBgm:String ' Path to Background Music file
	Field PathTileSet:String ' Path to Tileset file
	Field BGI:TImage ' Background Image
	Field BGM:TSound ' Background Music
	Field TileSet:TImage ' Tileset
	
	Field Tile:Int[,] ' Stores the framenumbers of the tileset
	
	Field ChnBGM:TChannel ' Channel for Background music
	
	Function Create:TLevel(tileSet:TImage, bgi:TImage = Null, bgm:TSound = Null)
		Local lvl:TLevel = New TLevel
		lvl.Tile = New Int[Width, Height]
		lvl.BGI = bgi
		lvl.BGM = bgm
		lvl.TileSet = tileSet
		Return lvl
	End Function
	
	
	Function CreateTemplateLevel(file:String)
		Local fileOut:TStream = WriteFile(file)
		If fileOut
			WriteLine(fileOut, "assets/levels/Backgroundimage.png")
			WriteLine(fileOut, "assets/levels/Backgroundmusic.ogg")
			WriteLine(fileOut, "assets/levels/Bricks.png")
			For Local y:Int = 0 To Height - 1
				For Local x:Int = 0 To Width - 1
					WriteLine(fileOut, 0)
				Next
			Next
			CloseFile(fileOut)
		End If

	End Function
	
	Function LoadLevel:TLevel(file:String)
		Local fileIn:TStream = ReadFile(file)
		Local level:TLevel
		If Not fileIn
			Notify "Level file not found!"
			End
		End If
		' save paths into string
		Local pathBgi:String  = ReadLine(fileIn)
		Local pathBgm:String = ReadLine(fileIn)
		Local pathTileSet:String = ReadLine(fileIn)
		' load resources into memory
		Local bgi:TImage = LoadImage(pathBgi)
		Local bgm:TSound = LoadSound(pathBgm, SOUND_LOOP)
		Local tileSet:TImage = LoadAnimImage(pathTileSet, TILEW, TileH, 0, NTILES)
		If Not tileset
			Notify "Tileset file not found!"
			End
		End If
		' create the level object
		level = TLevel.Create(tileSet, bgi, bgm)
		level.PathBgi = pathBgi
		level.PathBgm = pathBgm
		level.PathTileSet = pathTileSet
		' fill the tiles with framenumbers
		For Local y:Int = 0 To Height - 1
			For Local x:Int = 0 To Width - 1
				level.Tile[x, y] = Int(ReadLine(fileIn))
			Next
		Next
		CloseFile(fileIn)
		Return level
	End Function
	
	Method SaveLevel(file:String)
		Local fileOut:TStream = WriteFile(file)
		If fileOut
			WriteLine(fileOut, PathBgi)
			WriteLine(fileOut, PathBgm)
			WriteLine(fileOut, PathTileSet)
			For Local y:Int = 0 To Height - 1
				For Local x:Int = 0 To Width - 1
					WriteLine(fileOut, Tile[x, y])
				Next
			Next
			CloseFile(fileOut)
		Else
			Notify "Could not write file " + file
		End If
	End Method
	
	
	Method Render(shadow:Int = True)
		' Play Background music
		If BGM
			If Not ChnBGM Then ChnBGM = PlaySound(BGM)
		End If
		' Draw Background
		If BGI Then DrawImage(BGI, GWIDTH/2, GHEIGHT/2)
		' Draw Tiles
		For Local y:Int = 0 To Height - 1
			For Local x:Int = 0 To Width - 1
				If TileSet
					If shadow = True
						SetColor(0, 0, 0)
						SetAlpha(0.3)
						DrawImage(TileSet, x * TILEW + 8, y * TILEH + 8, Tile[x, y])
						SetColor(255, 255, 255)
						SetAlpha(1)
						DrawImage(TileSet, x * TILEW, y * TILEH, Tile[x, y])
					End If
				End If
			Next
		Next
	End Method
	
	
	
	
	' -------- Editor Functions ---------
	
	Field SelectedFrame:Int = 1
	Field ToggleGrid:Int = True
	
	Method Edit()
		' Draw the grid
		If ToggleGrid = True
			For Local y:Int = 0 To Height - 1
				For Local x:Int = 0 To Width - 1
					Rect(x * TILEW, y * TILEH, TILEW, TILEH)
				Next
			Next
		End If
		' Select frame with mousewheel
		SelectedFrame = SelectedFrame + MouseZSpeed()
		If SelectedFrame > NTILES - 1 Then SelectedFrame = NTILES -1
		If SelectedFrame < 1 Then SelectedFrame = 1
		
		' Draw the selected frame at mousepointer
		DrawImage(TileSet, MouseX() - TILEW/2, MouseY() - TILEH/2, SelectedFrame)
		
		' with left click set the tile frame of the tile which the mouse is hovering over
		If MouseDown(1)
			Tile[PickedX(), PickedY()] = SelectedFrame
		End If
		' with right click, delete the frame ( frame = 0 ... first tile in the tileset which must be transperent )
		If MouseDown(2)
			Tile[PickedX(), PickedY()] = 0
		End If
		' Save the level when key "S" was hit
		If KeyHit(KEY_S)
			Local curTime:String = CurrentTime()
			Local curDate:String = CurrentDate()
			curTime = Replace(curTime, ":", "_")
			curDate = Replace(curDate, " ", "_")
			SaveLevel("assets/levels/NEW_LEVEL_" + curTime + "_" + curDate + ".lev")
		End If
		' Turn Grid On/Off when key "G" was hit
		If KeyHit(KEY_G)
			ToggleGrid = 1 - ToggleGrid
		End If
		
		DrawText "G = Grid On/Off", 10, GHEIGHT - 60
		DrawText "S = Save Level", 10, GHEIGHT - 40
		DrawText "Mousewheel = Select Tile", 10, GHEIGHT - 20
		DrawText "Left Click = Place Tile", 300, GHEIGHT - 40
		DrawText "Right Click = Delete Tile", 300, GHEIGHT - 20

		
	End Method
	
	' Get the tile row which the mouse is hovering over
	Method PickedX:Int()
		Local row:Int = MouseX() / TILEW
		If row > 0 And row < Width
			Return row
		Else
			Return 0
		End If
	End Method
	' Get the tile collumn which the mouse is hovering over
	Method PickedY:Int()
		Local col:Int = MouseY() / TILEH
		If col > 0 And col < Height
			Return col
		Else
			Return 0
		End If
	End Method

End Type


' Draws a hollow rectangle
Function Rect(x:Float, y:Float, width:Float, height:Float)
	' top line
	DrawLine(x, y, x + width, y)
	' bottom line
	DrawLine(x, y + height, x + width, y + height)
	' left line
	DrawLine(x, y, x, y + height)
	' right line
	DrawLine(x + width, y, x + width, y + height)
End Function

