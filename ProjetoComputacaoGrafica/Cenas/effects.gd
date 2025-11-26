extends CanvasLayer
@onready var message_comeuMarmita = $ComeuMarmita
@onready var message_fimDeAula = $FimDeAula
@onready var label_fimDeAula = $LabelFimDeAula

func _ready() -> void:
	message_comeuMarmita.visible = false
	message_fimDeAula.visible = false
	Global.comeu_marmita_efeito.connect(show_alert_marmita_quick)
	Global.fim_de_aula.connect(show_alert_fimDeAula_quick)
	

func show_alert_marmita_quick(duration: float = 1.5):
	# 1. Define a mensagem e mostra
	message_comeuMarmita.visible = true
	
	await get_tree().create_timer(duration).timeout
	
	# 3. Esconde o Label
	message_comeuMarmita.visible = false

func show_alert_fimDeAula_quick(pmg_change: int , duration: float = 1.5):
	# 1. Define a mensagem e mostra
	message_fimDeAula.visible = true
	label_fimDeAula.text = "Perda de PMG = " + str(pmg_change)
	
	await get_tree().create_timer(duration).timeout
	
	# 3. Esconde o Label
	message_fimDeAula.visible = false
	label_fimDeAula.text = ""
