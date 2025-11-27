extends Node2D


@export var red_book_scene : PackedScene
@export var green_book_scene : PackedScene
@export var blue_book_scene : PackedScene

@onready var spawn_points_container = $SpawnPoints

func spawnar_livros_aleatoriamente():
	var locais_disponiveis = spawn_points_container.get_children()
		# 2. Verifica se tem locais suficientes
	if locais_disponiveis.size() < 3:
		printerr("ERRO: Você precisa de pelo menos 3 Spawn Points na cena!")


	# 3. shuffle
	locais_disponiveis.shuffle()
	
	# 4. Instancia os livros nos 3 primeiros locais da lista embaralhada
	criar_livro(red_book_scene, locais_disponiveis[0], "Red")
	criar_livro(green_book_scene, locais_disponiveis[1], "Green")
	criar_livro(blue_book_scene, locais_disponiveis[2], "Blue")

func criar_livro(scene: PackedScene, ponto: Marker2D, tipo: String):
	var livro = scene.instantiate()
	livro.position = ponto.position
	livro.tipo_do_livro = tipo
	add_child(livro)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnar_livros_aleatoriamente()
	Global.crieLivros.connect(spawnar_livros_aleatoriamente)
	var posicao_zero = $CC.position
	print(posicao_zero)
	for filho in get_children():
		if filho is StaticBody2D and filho.id != 1:
			#print(filho.id)
			pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("FUI LEIGO")
