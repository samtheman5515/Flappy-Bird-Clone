extends Node2D
var Player = load("res://Scripts/Player.gd")
signal pipe_clear
#BILL I BILLIEVE THIS IS BILLING ME
func _ready():
	print("NANANANANANANA NANANANANANANANA TALKING AWAY I DON'T KNOW WHAT TO SAY BUT I'M TO SAY I'LL SAY IT ANYWAY TAAAAAAAKE OOOOOOOOON MEEEEEEEE TAKE ON ME TAAAAAAAAKE MEEEEEEEE OOOOOOON TAKE ON ME ILL BEEEEEE GOOOOOOONE IN A DAY OR TWO ")
	$UpperPipe1/Sprite.flip_v = true
	$LowerPipe2/Sprite.flip_v = true


func _on_Visibility_screen_exited():
	queue_free()


func _on_ClearZone_area_exited(area):
	if area is Player:
		emit_signal("pipe_clear")
