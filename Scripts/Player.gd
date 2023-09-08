extends KinematicBody2D

var velocidade = 200
var forca_pular = -400.0
var gravidade = 800
var mover = Vector2()
onready var _player_sprite = get_node("Sprite")
onready var _player_audio_pular = get_node("AudioPular")

func _ready() -> void:
	add_to_group("load")

func _process(delta):
	# Movimentação horizontal
	var inserir_direcao = Vector2()
	inserir_direcao.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inserir_direcao = inserir_direcao.normalized()

	mover.x = inserir_direcao.x * velocidade

	# Pular
	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		mover.y = forca_pular
		_player_audio_pular.play()

	# Aplicar gravidade
	mover.y += gravidade * delta
	
	# Animar o personagem
	if inserir_direcao.x > 0:
		$Sprite.play("Andando")
		_player_sprite.flip_h = false
	elif inserir_direcao.x < 0:
		_player_sprite.flip_h = true
		$Sprite.play("Andando")
	else:
		$Sprite.play("Parado")
	if mover.y < 0:
		$Sprite.play("Pular")

	# Movimentar o personagem
	mover = move_and_slide(mover, Vector2(0, -1))


func _on_Sair_pressed() -> void:
	get_tree().call_group("load", "load_cena_menu")
