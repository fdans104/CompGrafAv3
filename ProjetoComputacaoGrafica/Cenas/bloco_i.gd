extends StaticBody2D
var id

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	id = 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.playerIn_I = true
		print("Jogador Dentro do Bloco I")



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.playerIn_I = false
		print("Jogador Saiu do Bloco I")
