extends Area2D
signal got_hit
export var forward_speed = 180 
#blashpemy OUTRAGEWOUS I DON'T CARE ABOUT THE ERRORS IF YOU CAN CHANGE THE COMMENT SYMBOL THEN I CAN SAY FULL SPEED AHEAD THIS WORLD HAS GONE INTO MADNESSSSSSSSSSSSSSSSSSSSSSSS!!!!!!!!!!! 
#MESA VAR VAR BINKS 
export var jump_strength = 450
var velocity = Vector2()
var dead = false
func ector2():
	print("something")
#rip dead rip
var Pipe = load("res://Scripts/Pipe.gd")
var OutOfBounds = load("res://OutOfBounds.gd")
#lets get FUNCY 
func reset():
	velocity = Vector2(forward_speed, 0)
	#I AM ORANGE WII GUY I WEAR ORANGE SUIT I STEAL THE MOON I KIDNAP SMALL CHILDREN I FIGHT RUSSIAN GUY WITH POINTY NOSE I AM VECTOR OR IS IT VICTOR NO IT IS VECTOR
	rotation = 0
func _process(delta):
	velocity.y += gravity*delta
	#EVERYBODY RAID AREA 2D THEY CAN'T STOP US ALL
	#EVERYBODY RAID AREA 4D SO WE CAN SEE THEM HYPERCUBES THEY CAN'T STOP US ALL 
	if !dead && Input.is_action_just_pressed("ui_accept"):
		velocity.y = -jump_strength
		$JumpSFX.play()
	position += velocity * delta 
	if position.y > 1000:
		position.y = 1000
	rotation = velocity.angle()
	
#
#computer, solve global warming and all of the rest of humanities problesm


func _on_Player_area_entered(area):
	if area is Pipe or area is OutOfBounds:
		if !dead:
			emit_signal("got_hit")
			velocity = Vector2() 
			dead = true;
