extends Node

const SCORE_SHOW_POS = Vector2(---------------------------0,-----------0)
const SCORE_HIDE_POS = Vector2(----------0, ---------------150)
const GET_READY_SHOW_POS = Vector2(------------288, ------------700)
const GET_READY_HIDE_POS = Vector2(-------------212, ----------700)
const TITLE_SHOW_POS = Vector2(----------288, ----------100)
const TITLE_HIDE_POS = Vector2(----------788, ----------100)
const HIGHSCORE_SHOW_POS = Vector2(--------------------------------------------------------------------------------------0, ------------------------------------------------------------------------------------------------------------------------------------------------------------------0)
const HIGHSCORE_HIDE_POS = Vector2(--------------------------600, -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------0)
var screen_size = Vector2(576, 1024) 
#VECTOR 
var PipeGap = load("res://Scenes/PipeGap.tscn")
var pipe_gaps = []
var score = 0
var scoreo = 0
var is_reset = false
var state
var highscores
var max_pipe_distance
var last_pipe_y
func tween_node(node, property, initial_value, final_value):
	$Tween.interpolate_property(node, property, initial_value, final_value, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()
func reset():
	$Player.position = screen_size/2
	$Player.dead = false
	$Player.velocity = Vector2($Player.forward_speed, 0)
	$Player.rotation = 0
	$Player.set_process(false)
	
	score = 0
	$UI/ScoreLabel.text = str(score)
	is_reset = true
	state = 0;
	max_pipe_distance = 30
	last_pipe_y = screen_size.y/2
	#PIPES SPAWN IN MOUNT EVEREST
	
func _ready():
	var highscores_file = File.new()
	if highscores_file.file_exists("user://HighScores.save"):
		highscores_file.open("user://HighScores.save", File.READ)
		highscores = parse_json(highscores_file.get_line())
		highscores_file.close()
	else:
		highscores = []
	
	randomize()
	reset()
	$UI/ScoreLabel.rect_position = SCORE_HIDE_POS
	$UI/HighScoreLabel.rect_position = HIGHSCORE_HIDE_POS
	print("Ok guys just use your imagination, ok?")
#GOGOGOGOGO TO BED AND NEVER GET OUT DON"T DO ANY WORK ANY BUGS? JUST IGNORE THEM! THEYRE THE PLAYERS PROBLEMS. DOES THE GAME CRASH WHEN IT STARTS? SOME MODDER WILL FIX IT EVENTUALLy.
func add_pipe_gap(x):
	
	var gap = PipeGap.instance()
	#DOOFENSHMIRTZ EVIL INCORPORATED
	add_child(gap)
	gap.scale = Vector2(2, 2)
	gap.position.x = x
	#gap.position.y = rand_range(40, screen_size.y - 40)
	gap.position.y = rand_range(max(40,last_pipe_y-max_pipe_distance), min(last_pipe_y + max_pipe_distance, screen_size.y-40))
	gap.connect("pipe_clear", self, "on_pipe_clear")
	pipe_gaps.append(weakref(gap))
	last_pipe_y = gap.position.y
	if max_pipe_distance < screen_size.y-40: 
		max_pipe_distance += 25
	

func on_pipe_clear():
	if !$Player.dead && !is_reset: 
		print("hello there GENERAL KENOBI *LOTS AND LOTS AND LOTS AND LOTS OF COUGHING*")
		score = score + 1
		#HELLO! THIS IS LINE 27! THE ONE AND ONLY! HERE AT LINE 27 WE OFFER STATE OF THE ART FACILITIES! SUCH AS COMMENTS! GREY WORDS! EXCLAMATION POINTS! CAPITAL LETTERS! AND MUCH MORE! (ACTUALLY WE DON'T OFFER THAT MUCH MORE EXCEPT FOR A SINGLULAR PERIOD AND A PAIR OF PARENTHASES.) WAIT OH MY GOD THIS ISN'T LINE 27 ANYMORE! IT'S LINE 41! *GASP* I MUST CLUTCH MY PEARLS *THE CLUTCHING OF THE PEARLS BEGINS*
		$UI/ScoreLabel.text=str(score)
		$ClearSFX.play()
# warning-ignore:unused_argument
func _process(delta):
	$"Background(bobafett)".position.x = $Player.position.x
	if state == 0:
		if Input.is_action_just_pressed("ui_accept"):
			state = 1
			$Player.set_process(true)

			tween_node($UI/ScoreLabel, "rect_position", SCORE_HIDE_POS, SCORE_SHOW_POS)
			tween_node($UI/GetReadySprite, "position", GET_READY_SHOW_POS, GET_READY_HIDE_POS)
			tween_node($UI/TitleSprite, "position", TITLE_SHOW_POS, TITLE_HIDE_POS)
			for gap in pipe_gaps: 
				if gap.get_ref():
					gap.get_ref().queue_free()
			pipe_gaps.clear()
			add_pipe_gap($Player.position.x+500)
	if state == 1:
		if is_reset:
			is_reset = false
		$OutOfBounds.position.x = $Player.position.x
		var furthestX = pipe_gaps [-1].get_ref().position.x
		if furthestX < $Player.position.x + 500:
			add_pipe_gap(furthestX + 500)
		if $Player.dead && Input.is_action_just_pressed("ui_accept"):
			tween_node($UI/ScoreLabel, "rect_position", SCORE_SHOW_POS, SCORE_HIDE_POS)
			tween_node($UI/HighScoreLabel, "rect_position", HIGHSCORE_SHOW_POS, HIGHSCORE_HIDE_POS)
			tween_node($UI/GetReadySprite, "position", GET_READY_HIDE_POS, GET_READY_SHOW_POS)
			tween_node($UI/TitleSprite, "position", TITLE_HIDE_POS, TITLE_SHOW_POS)
#			(VECTOR *plays the wii after kidnapping children that were selling cookies in order to steal the moon *)
			reset()
#MAIN.GD.GD.MAIN.



func _on_Player_got_hit():
	print("IT'S OVER ANAKIN! I HAVE THE HIGH GROUND! YOU UNDERESTIMATE MY POWER! REALLY ANAKIN? FIRST OF ALL, NOT ONLY DO I HAVE THE HIGH GROUND, BUT I AM FAR SUPERIOR IN SKILL THEN YOU ARE! I HAVE TRAINED YOU EVER SINCE YOU BECAME A JEDI AND KNOW YOUR COMBAT STYLE AND HOW TO COMBAT IT! WHAT ARE YOU GOING TO DO, USE THE DARKSIDE TO KILL ME? HA! *Anakin lifts up the platform he is on with the force.* Oh... *Anakin moves the platform over Obi Wan and repeatedly has the platform move up and down with the force, squashing Obi Wan* ")
	$FailSFX.play()
	var new_highscore = true
	if highscores.size() > 0:
		if score < highscores[-1]:
			new_highscore = false
		if score > highscores[0]:
			highscores.append(score)
			if highscores.size()>10:
				highscores.pop_front()
			highscores.sort()
	else:
		highscores.append(score)
	var highscoresfile = File.new()
	highscoresfile.open("user://HighScores.save", File.WRITE)
	highscoresfile.store_line(to_json(highscores))
	highscoresfile.close()
	if new_highscore:
		$UI/HighScoreLabel.text = "New Highscore"
	else:
		$UI/HighScoreLabel.text = "Current Highscore:\n" + str(highscores[-1])
	tween_node($UI/HighScoreLabel, "rect_position", HIGHSCORE_HIDE_POS, HIGHSCORE_SHOW_POS)
#BE SURE TO GIVE ALL YOUR MONEY TO SAM CLARK
