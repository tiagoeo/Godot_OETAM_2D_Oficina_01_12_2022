extends Node

# warning-ignore:unused_signal
signal sair

# warning-ignore:unused_signal

signal substituir_cena_principal 

export var menu : Resource

func _ready() -> void:
	OS.window_fullscreen = false
	carregar_menu_principal()


func carregar_menu_principal() -> void:
	if menu == null:
		menu = ResourceLoader.load("res://GUI/Menu.tscn")
		if menu != null:
			carregar_cena(menu)
	else:
		carregar_cena(menu)


func substituir_cena_principal(resource) -> void:
	call_deferred("carregar_cena", resource)


func carregar_cena(resource : Resource) -> void:
	var node = resource.instance()

	for child in get_children():
		remove_child(child)
		child.queue_free()
	add_child(node)

	node.connect("sair", self, "carregar_menu_principal")
	node.connect("substituir_cena_principal", self, "substituir_cena_principal")
