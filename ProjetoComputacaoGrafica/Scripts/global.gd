extends Node

# Livros
signal crieLivros

var leuOLivro_Red : bool = false
var leuOLivro_Green : bool = false
var leuOLivro_Blue : bool = false
var tempoPraMudança : int = 30
var penalidadePMG : int = 15

func registrar_leitura(tipo: String):
	match tipo:
		"Red": leuOLivro_Red = true
		"Green": leuOLivro_Green = true
		"Blue": leuOLivro_Blue = true
	atualiza_a_ui.emit()

func limpar_livros_da_cena():
	# Usando o grupo "Livros" para achar e deletar todos
	get_tree().call_group("Livros", "queue_free")




#------Marmitas
var marmita_gelada_count = 10
var marmita_count = 0
var marmita_nutricao = 5

signal atualiza_a_ui
signal atualiza_a_fome
signal comeu_marmita_efeito

func adicionarMarmitaQuente():
	marmita_count = marmita_count + 1
	atualiza_a_ui.emit()
	#Signal pro player atualizar UI
	
func ComerMarmitaQuente():
	marmita_count = marmita_count - 1
	#Signal pro player atualizar fome
	atualiza_a_ui.emit()
	#Signal pro player atualizar UI
	atualiza_a_fome.emit()
	#Signal pro efeito especial
	comeu_marmita_efeito.emit()
	
	

func perderMarmitaFria():
	marmita_gelada_count = marmita_gelada_count - 1
	atualiza_a_ui.emit()
	#Signal pro player atualizar UI

func adicionarMarmitaFria(value: int):
	marmita_gelada_count = marmita_gelada_count + value
	atualiza_a_ui.emit()
	#Signal pro player atualizar UI

#Aulas

signal fim_de_aula

# --- Configurações Fixas ---
var blocos_disponiveis = ["Bloco C", "Bloco I", "Bloco J"]
var destinoPalestra = "Biblioteca"

# --- Controle ---
var playerIn_C = false
var playerIn_I = false
var playerIn_J = false
var playerIn_Biblioteca = false

# --- Variáveis
var destinoAB : String = ""
var destinoCD : String = ""
var destinoEF : String = ""

var tempo_atual = 0

func definir_aulas_do_dia():
	var sorteio = blocos_disponiveis.duplicate()
	sorteio.shuffle()
	destinoAB = sorteio[0] 
	destinoCD = sorteio[1] 
	destinoEF = sorteio[2]
	
	# Debug
	print("--- NOVA AGENDA DE AULAS ---")
	print("Aula AB: " + destinoAB )
	print("Aula CD: " + destinoCD )
	print("Aula EF: " + destinoEF )
	print("Palestra: " + destinoPalestra)
