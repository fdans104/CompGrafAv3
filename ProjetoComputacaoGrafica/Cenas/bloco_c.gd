extends StaticBody2D

var id
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	id = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.playerIn_C = true
		print("Jogador Dentro do Bloco C")



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.playerIn_C = false
		print("Jogador Saiu do Bloco C")
