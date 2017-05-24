

SuperStrict

Framework BRL.D3D9Max2D
Import BRL.FileSystem
Import BRL.DirectSoundAudio
Import BRL.PNGLoader
Import BRL.WAVLoader
Import BRL.OGGLoader
Import BRL.Retro
Import BRL.Timer

Include "TGame.bmx"
Include "TLevel.bmx"
Include "TBall.bmx"
Include "TPaddle.bmx"

AppTitle = "BrickZone_v0.1 by Michael Frank"



SetGraphicsDriver D3D7Max2DDriver()

Graphics GWIDTH, GHEIGHT
SetBlend(ALPHABLEND)
AutoMidHandle(True)

Local Game:TGame = New TGame
Game.Execute()


