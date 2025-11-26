extends CharacterBody2D

var SPEED = 300.0
var ultima = ""
var pmg = 100
var hunger = 0
var hunger_max = 15
var health = 10
var time_aula = 25
var time = time_aula
var boost = true
var boost_time = 5
var cool_down = 15

var destino : String = "..."

@onready var label_time = $Camera2D/HUD/TIME

@onready var sprite = $AnimatedSprite2D
@onready var timerHunger = $TimerHunger
@onready var label_pmg = $Camera2D/HUD/Panel/HBoxContainer/PMG
@onready var label_saude = $"Camera2D/HUD/Panel/HBoxContainer3/Saúde"
@onready var label_mfria = $"Camera2D/HUD/VBoxContainer/HBoxContainer/marmitas frias"
@onready var label_mquente = $"Camera2D/HUD/VBoxContainer/HBoxContainer2/marmitas quentes"
@onready var label_destino = $Camera2D/HUD/DESTINO
@onready var progb_fome = $Camera2D/HUD/Panel/HBoxContainer2/VBoxContainer/FomeBar


@onready var redContainer = $Camera2D/HUD/VBoxContainer/RedContainer
@onready var greenContainer = $Camera2D/HUD/VBoxContainer/GreenContainer
@onready var blueContainer = $Camera2D/HUD/VBoxContainer/BlueContainer


func _ready() -> void:
	progb_fome.max_value = hunger_max
	progb_fome.value = hunger
	
	label_time.text = str(time)
	
	Global.definir_aulas_do_dia()
	redContainer.hide()
	greenContainer.hide()
	blueContainer.hide()
	ultima = "down"
	atualizar_ui()
	Global.atualiza_a_ui.connect(atualizar_ui)
	Global.atualiza_a_fome.connect(recuperar_fome.bind(Global.marmita_nutricao))
	set_destino(Global.blocos_disponiveis[Global.tempo_atual])



func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("boost"):
		if boost:
			SPEED = 600
			boost = false
			$BoostTime.start()

	if Input.is_action_pressed("up"):
		velocity.y = -1
		ultima = "up"
	elif Input.is_action_pressed("down"):
		velocity.y = 1
		ultima = "down"
	
	if Input.is_action_pressed("left"):
		velocity.x = -1
		ultima = "left"
	elif Input.is_action_pressed("right"):
		velocity.x = 1
		ultima = "right"
	
	if velocity != Vector2.ZERO:
		velocity = velocity.normalized() * SPEED
		#move_and_slide()
		position += velocity * delta
	move_and_slide()
	var collision_count = get_slide_collision_count()
	if collision_count > 0:
		var collision = get_slide_collision(collision_count-1)
		var corpo_colidido = collision.get_collider()
		if corpo_colidido is StaticBody2D:
			var id = corpo_colidido.id
			if id == 1:
				print("COLIDIMOS COM O CC!")
			elif id == 2:
				print("COLIDIMOS COM O BLOCO C!")
			elif id == 3:
				print("COLIDIMOS COM A BIBLIOTECA")
				
			elif id == 4:
				print("COLIDIMOS COM O BLOCO J")
			elif id == 5:
				print("COLIDIMOS COM O BLOCO I")
				
	#else:
	#	move_and_slide()
	
	# ----- ANIMAÇÕES -----
	if velocity != Vector2.ZERO:
		match ultima:
			"up":
				sprite.play("walk_up")
			"down":
				sprite.play("walk_down")
			"left":
				sprite.play("walk_left")
			"right":
				sprite.play("walk_right")
	else:
		match ultima:
			"up":
				sprite.play("idle")
			"down":
				sprite.play("idle2")
			"left":
				sprite.play("idle3")
			"right":
				sprite.play("idle4")


func _on_timer_hunger_timeout() -> void:
	hunger += 1
	if hunger > hunger_max:
		if Global.marmita_count > 0:
			Global.ComerMarmitaQuente()
			@warning_ignore("integer_division")
			recuperar_fome(hunger_max/4)
			return
		loseHealth(1)
		hunger = hunger_max
	progb_fome.value = hunger
	timerHunger.start(3)

func loseHealth(points) -> void:
	health -= points
	label_saude.text = "Saúde: " + str(health)
	if health <= 0:
		print("Game Over!")
		
		
	


func _on_main_timer_timeout() -> void:
	time -= 1
	
	if time < 10 and time > 0:
		pass
		
	
	if time > 0:
		$Camera2D/HUD/TIME.text = str(time)
	else:
		var pmg_change : int
		
		match destino:
			"Bloco I":
				if Global.playerIn_I:
					print("O player está no bloco I e a aula foi aqui")
					pmg_change = 15
				else:
					print("O player perdeu 15 pontos da PMG por não estar no bloco I")
			"Bloco C":
				if Global.playerIn_C:
					print("O player está no bloco C e a aula foi aqui")
					pmg_change = 15
				else:
					print("O player perdeu 15 pontos da PMG por não estar no bloco C")
			"Bloco J":
				if Global.playerIn_J:
					print ("O player está no bloco J e a aula foi aqui")
					pmg_change = 15
				else:
					print("O player perdeu 15 pontos da PMG por não estar no bloco J")
		
		pmg_change = pmg_change - 30
		if Global.leuOLivro_Red:
			pmg_change = pmg_change + 5
		if Global.leuOLivro_Green:
			pmg_change = pmg_change + 5
		if Global.leuOLivro_Blue:
			pmg_change = pmg_change + 5
		pmg = pmg + pmg_change
		Global.limpar_livros_da_cena()
		Global.leuOLivro_Blue = false
		Global.leuOLivro_Red  = false
		Global.leuOLivro_Green = false
		if Global.tempo_atual == 2:
			Global.tempo_atual = 0
		else:
			Global.tempo_atual += 1
		set_destino(Global.blocos_disponiveis[Global.tempo_atual])
		atualizar_ui()
		Global.crieLivros.emit()
		Global.fim_de_aula.emit(pmg_change)
		time =  time_aula
		
		
		


func _on_boost_time_timeout() -> void:
	boost_time -= 1
	if boost_time > -1:
		$Camera2D/HUD/Boost_time.text = str(boost_time)
	else:
		boost_time = 5
		$BoostTime.stop()
		$Camera2D/HUD/BOOST.text = "COOLDOWN:"
		$Camera2D/HUD/Boost_time.text = "20"
		$Camera2D/HUD/Boost_time.position.x += 50
		SPEED = 300
		$CoolDown.start()
		

func _on_cool_down_timeout() -> void:
	cool_down -= 1
	if cool_down > -1:
		$Camera2D/HUD/Boost_time.text = str(cool_down)
	else:
		cool_down = 20
		$CoolDown.stop()
		$Camera2D/HUD/BOOST.text = "BOOST:"
		$Camera2D/HUD/Boost_time.text = "5"
		$Camera2D/HUD/Boost_time.position.x -= 50
		boost = true

func atualizar_ui():
	label_mfria.text = "Marmitas Geladas: " + str(Global.marmita_gelada_count)
	label_mquente.text = "Marmitas Quentes: " + str(Global.marmita_count)
	
	label_pmg.text = str(pmg)
	
	progb_fome.value = hunger
	atualizar_ui_books()

func atualizar_ui_books():
	if Global.leuOLivro_Red:
		redContainer.show()
	else:
		redContainer.hide()

	if  Global.leuOLivro_Green:
		greenContainer.show()
	else:
		greenContainer.hide()

	if Global.leuOLivro_Blue:
		blueContainer.show()
	else:
		blueContainer.hide()




func recuperar_fome(value: int):
	hunger -= value
	
	if hunger < 0:
		hunger = 0
	atualizar_ui()

func set_destino(destinoGlobal : String):
	destino = destinoGlobal
	print(destino)
	label_destino.text = str(destino)
