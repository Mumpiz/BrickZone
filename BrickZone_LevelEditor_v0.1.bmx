Strict

Framework BRL.D3D9Max2D
Import BRL.FileSystem
Import BRL.DirectSoundAudio
' modules which may be required:
Import BRL.PNGLoader
' Import BRL.BMPLoader
' Import BRL.TGALoader
' Import BRL.JPGLoader
Import BRL.WAVLoader
Import BRL.OGGLoader
Import BRL.Retro

Include "TLevel.bmx"

AppTitle = "BrickZone Level Editor_v0.1 by Michael Frank"

SetGraphicsDriver D3D7Max2DDriver()








' ######################################################################################################


Graphics GWIDTH, GHEIGHT
SetBlend(ALPHABLEND)


TLevel.CreateTemplateLevel("assets/levels/template.lev")

Local level:TLevel = TLevel.LoadLevel("assets/levels/template.lev")


Repeat
Cls

	' level.Update()
	level.Render()
	level.Edit()
	




Flip(1)
Until AppTerminate() Or KeyDown(KEY_ESCAPE)






























