

Type TGame

	Field GameTimer:TTimer = CreateTimer(60)

	Field PauseMode:Int = False
	
	' Sounds
	Field SndBrickHit:TSound
	Field SndPaddleHit:TSound
	' Images
	Field ImgPaddle:TImage
	Field ImgBall:TImage
	
	Field Level:TLevel
	
	Field Paddle:TPaddle
	
	' List of all ball objects
	Field Balls:TList = New TList

	Method OnCreate()
		' Sounds
		SndBrickHit = LoadSound("assets/sounds/brickhit.wav")
		SndPaddleHit = LoadSound("assets/sounds/paddlehit.wav")
		' Images
		ImgPaddle = LoadImage("assets/images/paddle.png")
		ImgBall = LoadImage("assets/images/ball.png")
		
		' Create the Paddle
		Paddle = TPaddle.Create( GWIDTH / 2, GHEIGHT - 50, ImgPaddle )
		Level = TLevel.LoadLevel("assets/levels/test2.lev")
		
		Balls.AddLast(TBall.Create(ImgBall, GWIDTH / 2, GHEIGHT / 2))
		
	End Method
	
	Method OnStart()
	
	
	End Method
	
	
	Method OnUpdate()
		UpdateBalls(Balls, Paddle, Level)
		Paddle.Update()
	End Method
	
	Method OnRender()
	Cls
		Level.Render()
		RenderBalls(Balls)
		Paddle.Render()
	Flip(1)
	End Method


	Method Execute()
		OnCreate()
		Repeat
			OnUpdate()
			OnRender()
		WaitTimer(GameTimer)
		Until AppTerminate() Or KeyDown(KEY_ESCAPE)
	End Method


End Type




Function UpdateBalls(balls:TList, paddle:TPaddle, level:TLevel)
	For Local ball:TBall = EachIn balls
		ball.Update(GWIDTH, GHEIGHT, paddle, level)
	Next
End Function


Function RenderBalls(balls:TList)
	For Local ball:TBall = EachIn balls
		ball.Render()
	Next
End Function


