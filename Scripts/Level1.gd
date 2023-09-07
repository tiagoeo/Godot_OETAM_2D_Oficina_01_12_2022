extends Node2D
# warning-ignore:unused_signal
signal substituir_cena_principal

# warning-ignore:unused_signal
signal sair

onready var _audio_level = get_node("Audio/AudioLevel")

func _ready() -> void:
	_audio_level.play()
