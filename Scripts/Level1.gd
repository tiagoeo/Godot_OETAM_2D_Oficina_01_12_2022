extends Node2D
# warning-ignore:unused_signal
signal substituir_cena_principal

# warning-ignore:unused_signal
signal sair

signal load_cena 

var res_loader : ResourceInteractiveLoader = null
var loading_thread : Thread = null

onready var ui = $UI
onready var carregamento = ui.get_node(@"Carregamento")
onready var carregando_cronometro = carregamento.get_node(@"TimerCarregamento")
onready var carregando_progresso = carregamento.get_node(@"ProgressBarCarregamento")

onready var _audio_level = get_node("Audio/AudioLevel")

var _menu = "res://GUI/Menu.tscn"
var _next_level = "res://Levels/Level1.tscn"

func _ready() -> void:
	_audio_level.play()
	add_to_group("load")
	
func interactive_load(loader) -> void:
	while true:
		var status = loader.poll()
		if status == OK:
			carregando_progresso.value = (loader.get_stage() * 100) / loader.get_stage_count()
			continue
		elif status == ERR_FILE_EOF:
			carregando_progresso.value = 100
			carregando_cronometro.start()
			break
		else:
			print("Erro no carregamento do level: " + str(status))
			break

func loading_done(loader) -> void:
	loading_thread.wait_to_finish()
	emit_signal("substituir_cena_principal", loader.get_resource())
	res_loader = null

func carregar_level(path) -> void:
	if ResourceLoader.has_cached(path):
		emit_signal("substituir_cena_principal", ResourceLoader.load(path))
	else:
		res_loader = ResourceLoader.load_interactive(path)
		loading_thread = Thread.new()
		#warning-ignore:return_value_discarded
		loading_thread.start(self, "interactive_load", res_loader)

func load_cena_menu() -> void:
	carregamento.show()
	carregar_level(_menu)
	
func load_cena_next_level() -> void:
	carregamento.show()
	carregar_level(_next_level)
