extends Node
signal substituir_cena_principal

# warning-ignore:unused_signal
signal sair

var res_loader : ResourceInteractiveLoader = null
var loading_thread : Thread = null

onready var ui = $UI
onready var menu_principal = ui.get_node(@"MenuPrincipal")
onready var btn_comecar_menu_principal = menu_principal.get_node(@"btnComecar")

onready var menu_configuracao = ui.get_node(@"MenuConfiguracoes")

onready var carregamento = ui.get_node(@"Carregamento")
onready var carregando_cronometro = carregamento.get_node(@"TimerCarregamento")
onready var carregando_progresso = carregamento.get_node(@"ProgressBarCarregamento")

func _ready() -> void:
	carregamento.hide()
	menu_configuracao.hide()
	menu_principal.visible = true
	
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
			menu_principal.show()
			carregamento.hide()
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

func _on_TimerCarregamento_timeout() -> void:
	loading_done(res_loader)

func _on_btnComecar_pressed() -> void:
	var path = "res://Levels/Level1.tscn"
	carregamento.show()
	menu_configuracao.hide()
	menu_principal.hide()
	carregar_level(path)
