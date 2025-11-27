extends Area2D

var tipo_do_livro : String = "" # Será preenchido pelo Spawner ("Red", "Green", "Blue")



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.registrar_leitura(tipo_do_livro)
		print("Livro " + tipo_do_livro + " coletado!")
		queue_free()
		
