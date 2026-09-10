programa
{
	inclua biblioteca Texto --> txt
	inclua biblioteca Util --> u
	
	cadeia matriz[8][12], direcao = "d", itens[30], pos_caixa, GLOBAL_opcao, GLOBAL_inventario[5][6], GLOBAL_arquivos_ambiente[7], arma
	cadeia texto_daemon[7] = {
		
		"     ░▓▓░    ░▓▓░      ",
		"     ░▓▓▓▓▓▓▓▓▓▓░      ",
		"     ░▓▓▓▓▓▓▓▓▓▓░      ",
		"    ░▓▓▓▓▓▓▓▓▓▓▓▓░     ",
		"    ░▓▓▓▓▓▓▓▓▓▓▓▓░     ",
		"      ░▒▓▓▓▓▓▓▒░       ",
		"        ░▓▓▓▓░         "
	}
	cadeia texto_jogador[7] = {
		
	    "        ▒▒▒▒▒▒▒        ",
	    "      ░▓░░░  ░ ▓░      ",
	    "      █▒░░█  █░ ▓      ",
	    "      ██▒░░░░░░██      ",
	    "       ██▓▓▓▓▓▓█       ",
	    "       ██▓███▓▓█       ",
	    "       ▓███ ▓███       "
	}
	cadeia texto_desconhecido[7] = {
		
		"       ████████        ",
		"      ████  ████       ",
		"          ██████       ",
		"        ███████        ",
		"                       ",
		"         ████          ",
		"         ████          "
	}

	inteiro y = 4, x = 1, anterior_x = 0, anterior_y = 4, fase = 0, integridade = 100, bits = integridade
	inteiro x_chave, y_chave, possui_chave[5], n_itens = 0
	inteiro x_caixa[3], y_caixa[3], caixa_moviday, caixa_movidax
	const inteiro integridade_inimigo = 100
	inteiro bits_inimigo = integridade_inimigo
	real versao = 1.0, kernel = 0.0
	logico parou_por_algum_motivo = falso, porta_saida = falso, porta_entrada = falso, segurando_caixa = falso



	funcao inicio(){

		para(inteiro i = 0; i < 5; i++){
			para(inteiro j = 0; j < 6; j++){
				se(i != 0 ou j != 0 e j != 1){
					GLOBAL_inventario[i][j] = "."
				}senao se(j == 0){
					GLOBAL_inventario[i][j] = "0"
					n_itens++
					itens[(i * 6) + j] = "0"
				}senao se(j == 1){
					GLOBAL_inventario[i][j] = "1"
					n_itens++
					itens[(i * 6) + j] = "1"
				}
			}
		}

		logico pular_dialogo
		cadeia comandos

		pular_dialogo = terminalQuest()
		
		se(nao pular_dialogo){
			fala_inicial()
		}

		abrir_terminal()
	}
	
	funcao fala_inicial(){
		falas("- ... Hummm, o que?^      Onde estou?", 76, "jogador")
		falas("- Que dor de cabeça^//jogador se levanta^  Mas o quê é isso???^//diz olhando ao horizonte", 76, "jogador")
		falas("- \"Isso\"? Você fala como se eu fosse uma    coisa^//diz um ser se aproximando ao longe", 76, "desconhecido")
		falas("- Eu sou um Daemon, um processo abandonado^  sem um PID 1...", 76, "daemon")
		falas("- Ok, mas o que é este mundo?", 76, "jogador")
		falas("- Não. A pergunta certa é: em qual Versão dele você acordou?", 76, "daemon")
		falas("- Nós chamamos esta terra de terminal", 76, "daemon")
		falas("- Espera, tipo o terminal do computador?", 76, "jogador")
		falas("- Exatamente", 76, "daemon")
		falas("- Ok... Mas o que é aquilo?^//diz o jogador olhando ao longe uma gigantesca montanha", 76, "jogador")
		falas("- Isso você descobrirá em breve...", 76, "daemon")
	}

	funcao falas(cadeia texto, inteiro velocidade, cadeia locutor){

		cadeia texto_exibido[9] = {"", "", "", "", "", "", "", "", ""}, passar_dialogo, retrato[7]
		inteiro numero_caracteres = txt.numero_caracteres(texto), linha = 2, limite_linha = 40

		para(inteiro i = 0; i < 7; i++){
			se(locutor == "daemon"){
				retrato[i] = texto_daemon[i]
			}senao se(locutor == "jogador"){
				retrato[i] = texto_jogador[i]
			}senao se(locutor == "desconhecido"){
				retrato[i] = texto_desconhecido[i]
			}
			
		}

		para(inteiro i = 0; i < numero_caracteres; i++){

			caracter c = txt.obter_caracter(texto, i)

				se(c != '^'){
					texto_exibido[linha] += c
				}

			escreva("┌───────────────────────┐\n")
			se((txt.numero_caracteres(texto_exibido[linha]) >= limite_linha e c == ' ') ou c == '^'){
					linha++
			}
			
			para(inteiro j = 0; j < 7; j++){
				se(c != '^'){
					escreva("│", retrato[j], "│     ", texto_exibido[j], "\n")
				}
			}
			escreva("└───────────────────────┘")
			se(i == numero_caracteres - 1){
				escreva("     PRESSIONE ENTER PARA CONTINUAR: ")
				leia(passar_dialogo)
				se(passar_dialogo == "1"){
					pare
				}
			}senao{
				u.aguarde(u.sorteia(velocidade - 75, velocidade + 10))
			}
			limpa()
		}
	}

	funcao define_caractere(){
		para(inteiro i = 0; i < 8; i++){
			para(inteiro j = 0; j < 12; j++){
				se(j == 11 ou j == 0){
					matriz[i][j] = "|"
				}senao se(i == 7 ou i == 0){
					matriz[i][j] = "—"
				}senao se(y == i e x == j){
					matriz[i][j] = "#"
				}senao se(fase == 0 e i == 1 e j == 7 e possui_chave[fase] == 0){
					matriz[i][j] = "+"
					x_chave = j
					y_chave = i
				}senao se(fase == 1 e i == 1 e j == 7 e possui_chave[fase] == 0){
					matriz[i][j] = "+"
					x_chave = j
					y_chave = i
				}senao se(validacao_caixa(j, i)){
					matriz[i][j] = "□"
				}senao{
					matriz[i][j] = "."
				}
			}
		}
		se((possui_chave[fase] == 1)){
			matriz[3][11] = "\\"
			matriz[4][11] = "/"
			porta_saida = verdadeiro
		}
		se((fase > 0)){
			matriz[3][0] = "\\"
			matriz[4][0] = "/"
			porta_entrada = verdadeiro
		}
	}

	funcao desenha_matriz(){
		limpa()
		escreva("operator@kernel:/world/sector_0", fase, "$ cat map.txt\n\nsector_0", fase, ".map  [kernel ", versao, "]\n\n")
		para(inteiro i = 0; i < 8; i++){
			escreva("   ")
		para(inteiro j = 0; j < 12; j++){
			escreva(matriz[i][j], "  ")
		}
			escreva("\n")
		}
	}

	funcao movimentacao(){
  
		escreva("\ncwd: /world/sector_0", fase, "\npos: (", x, ",", y, ")\ninput: ")
		leia(direcao)
	  
		se(direcao == "d"){
			se(possui_chave[fase] == 1 e (y == 3 ou y == 4) e x == 10){
				fase++
				porta_saida = falso
				possui_chave[fase] = 0
				x = 1
				y = 4
			}senao se(x < 10 e nao validacao_caixa(x + 1, y)){
				anterior_x = x
				anterior_y = y
				x++
				encontrar_agente()
			}
		}senao se(direcao == "a" e x >= 1){
			se(porta_entrada e (y == 3 ou y == 4) e x == 1){
				fase--
				x = 10
				y = 4
				possui_chave[fase] = 0
				porta_saida = verdadeiro
			}senao se(x < 10 e nao validacao_caixa(x - 1, y)){
				anterior_x = x
				anterior_y = y
				x--
				encontrar_agente()
			}
		}senao se(direcao == "w" e y > 1 e nao validacao_caixa(x, y - 1)){
			anterior_x = x
			anterior_y = y
			y--
			encontrar_agente()
		}senao se(direcao == "s" e y < 6 e nao validacao_caixa(x, y + 1)){
			anterior_x = x
			anterior_y = y
			y++
			combate()
		}senao se(direcao == "1"){
			fase = 1
		}senao se(direcao == " "){
			segurando_caixa = verdadeiro
			anterior_x = 1
			anterior_y = 2
			mover_caixa()
		}senao se(direcao == "^c"){
			abrir_terminal()
			parou_por_algum_motivo = verdadeiro
		}
		se((x == x_chave e y == y_chave) ou direcao == "21"){
			possui_chave[fase] = 1
			adicionar_item("gate_0" + fase + ".key")
		}
	}

	funcao logico validacao_caixa(inteiro x_, inteiro y_){
		se(fase == 1 ou segurando_caixa){
			se(segurando_caixa){
				x_caixa[2] = anterior_x
				y_caixa[2] = anterior_y
			}senao{
				x_caixa[2] = 1
				y_caixa[2] = 2
			}
		}
		logico eh_caixa = falso
		para(inteiro i = 0; i < 3; i++){
			se(x_ == x_caixa[i] e y_ == y_caixa[i]){
				eh_caixa = verdadeiro
	    		}
		}
		retorne eh_caixa
	}

	funcao logico caixa_perto(){
		logico tem_caixa = falso
			se(validacao_caixa(x, y - 1)){
				tem_caixa = verdadeiro
				pos_caixa = "cima"
			}senao se(validacao_caixa(x, y + 1)){
				tem_caixa = verdadeiro
				pos_caixa = "baixo"
			}senao se(validacao_caixa(x - 1, y)){
				tem_caixa = verdadeiro
				pos_caixa = "esquerda"
			}senao se(validacao_caixa(x + 1, y)){
				tem_caixa = verdadeiro
				pos_caixa = "direita"
			}
		retorne tem_caixa
	}

	funcao escreva_lento(cadeia texto, inteiro velocidade){
		inteiro passar_dialogo
		inteiro numero_caracteres = txt.numero_caracteres(texto)

		para(inteiro i = 0; i < numero_caracteres; i++){
			escreva(txt.obter_caracter(texto, i))
			u.aguarde(u.sorteia(velocidade - 50, velocidade + 50))
		}
	}

	funcao mover_caixa(){
		caixa_perto()
	}
	
	funcao logico terminalQuest(){

		logico pular_dialogo = falso
		cadeia continuar
		
		escrevaTerminal()
			u.aguarde(1000)
			limpa()
		escrevaQuest(1)
			u.aguarde(1000)
			limpa()
		escrevaTerminal()
		escrevaQuest(2)
		escreva("PRESSIONE ENTER PARA CONTINUAR: ")
		leia(continuar)
		se(continuar == "1"){pular_dialogo = verdadeiro}
		limpa()

		retorne pular_dialogo
	}
	
	funcao menu(){
		escreva("\n/===========================================\\ \n")
		escreva("||                                         ||     COMANDOS SUPORTADOS:\n")
		escreva("||                                         ||\n")
		escreva("||                                         ||\n")
		escreva("||                                         ||     > boot;\n")
		escreva("||   01101101  01100101 01101110 01110101  ||\n")
		escreva("||    .-.-.-.   .---.   .-..-.   .-..-.    ||     > ls -l inv;\n")
		escreva("||    | | | |   | |-    | .` |   | || |    ||\n")
		escreva("||    `-'-'-'   `---'   `-'`-'   `----'    ||     > ls;\n")
		escreva("||                                         ||\n")
		escreva("||                                         ||     > help;\n")
		escreva("||                                         ||\n")
		escreva("||                                         ||     > logout;\n")
		escreva("\\===========================================/\n")

		abrir_terminal()
	}

	funcao escrevaTerminal(){
		escreva("  _________  _______   ________  _____ ______   ___  ________   ________  ___          \n",
		        " |\\___   ___\\\\  ___ \\ |\\   __  \\|\\   _ \\  _   \\|\\  \\|\\   ___  \\|\\   __  \\|\\  \\         \n",
		        " \\|___\\  \\_\\ \\   __/|\\ \\  \\|  \\ \\  \\  \\\\__\\\\  \\  \\  \\  \\\\ \\  \\  \\  \\|  \\ \\ \\  \\      \n",
		        "     \\ \\  \\ \\ \\  \\_|/_\\ \\   _  _\\ \\  \\\\|__| \\  \\  \\  \\  \\\\ \\  \\  \\   __  \\ \\  \\       \n",
		        "      \\ \\  \\ \\ \\  \\_|\\ \\ \\  \\\\  \\\\ \\  \\    \\ \\  \\  \\  \\  \\\\ \\  \\  \\  \\ \\  \\ \\  \\____  \n",
		        "       \\ \\__\\ \\ \\_______\\ \\__\\\\ _\\\\ \\__\\    \\ \\__\\ \\__\\ \\__\\\\ \\__\\ \\__\\ \\__\\ \\_______\\ \n",
		        "        \\|__|  \\|_______|\\|__|\\|__|\\|__|     \\|__|\\|__|\\|__| \\|__|\\|__|\\|__|\\|_______|\n")
	}

	funcao escrevaQuest(inteiro chamada){
		se(chamada == 1){escreva("\n\n\n\n\n\n\n")}
	   escreva(  " ________  ___  ___  _______   ________  _________                                    \n",
		        "|\\   __  \\|\\  \\|\\  \\|\\  ___ \\ |\\   ____\\|\\___   ___\\                                  \n",
		        "\\ \\  \\|\\  \\ \\  \\\\  \\ \\   __/|\\ \\  \\___|\\|___ \\  \\_|                                  \n",
		        " \\ \\  \\\\  \\ \\  \\\\  \\ \\  \\_|/_\\ \\_____  \\   \\ \\   \\                                    \n",
		        "  \\ \\  \\\\  \\ \\  \\\\  \\ \\  \\_|\\ \\|____|\\  \\   \\ \\   \\                                  \n",
		        "   \\ \\_____  \\ \\_______\\ \\_______\\____\\_\\  \\   \\ \\__\\                                 \n",
		        "    \\|___| \\__\\|_______|\\|_______|\\_________\\   \\|__|                                 \n",
		        "          \\|__|                  \\|_________|                                           ")
	}
	
	funcao chameJogo(){
		enquanto(nao parou_por_algum_motivo){
			define_caractere()
			desenha_matriz()
			movimentacao()
		}
	}

	funcao ajude(){
		cadeia c
		
		escreva("\nComandos:\n")
		escreva("\nboot          - Comece a jogar")
		escreva("\ncat inventory - Olhar inventario")
		escreva("\nls            - Olhe o ambiente")
		escreva("\nlogout        - Sair do jogo")
		escreva("\n\n\nComo Jogar:")
		escreva("\n\nwasd para movimentação, confirme com ENTER após cada tecla")
		escreva("\nColete as chaves(+) para abrir as portas e passar de nível.\n")
		abrir_terminal()
	}

	funcao mostrar_inventario(){

		cadeia sair
		
		escreva("\ntotal ", n_itens, "\n\n")
		
		para(inteiro i = 0; i < 5; i++){
			para(inteiro j = 0; j < 6; j++){
				se(GLOBAL_inventario[i][j] != "."){
					escreva("-rw------- daemon root 1.0K ", GLOBAL_inventario[i][j], "\n")
				}
			}
		}
		abrir_terminal()
	}

	funcao adicionar_item(cadeia item){
		para(inteiro i = 0; i < 5; i++){
			para(inteiro j = 0; j < 6; j++){
				se(GLOBAL_inventario[i][j] == "."){
					GLOBAL_inventario[i][j] = item
					n_itens++
					retorne
				}
			}
		}
	}

	funcao abrir_terminal(){
		
		cadeia comando
		
		escreva("\noperator@kernel:~$: ")
		leia(comando)
		
		se(comando == "cat map.txt")			{chameJogo()}
		senao
		se(comando == "ls -l inv")		{mostrar_inventario()}
		senao
		se(comando == "ls")				{listar_ambiente()}
		senao 
		se(comando == "logout"){
			escreva("\nlogout")
			u.aguarde(200)
			limpa()
			escreva("\noperator@kernel:~$: logout\n\nlogout.")
			u.aguarde(200)
			limpa()
			escreva("\noperator@kernel:~$: logout\n\nlogout..")
			u.aguarde(200)
			limpa()
			escreva("\noperator@kernel:~$: logout\n\nlogout...")
			u.aguarde(200)
			limpa()
			escreva("\noperator@kernel:~$: logout\n\nlogout")
			u.aguarde(200)
			limpa()
			escreva("\noperator@kernel:~$: logout\n\nlogout\n\nNo active world found outside this session.\n")
			abrir_terminal()
			
		}
		senao
		se(comando == "help")			{ajude()}
		senao
		se(comando == "cat readme.txt")	{menu()}
		senao
		se(comando == "clear")			{limpa() abrir_terminal()}
		senao{						escreva("\nbash: command not found\nCurrent directory: /home/operator\nHint: use 'cat readme.txt' to open the menu.\n") abrir_terminal()}
	}

	funcao listar_ambiente(){

		inteiro n_arquivos = 0
		cadeia arquivos_ambiente[7]
		logico chave_listada = falso
		logico rocha_listada = falso

		//Verifica se os valores referentes a chave e a rocha já foram atribuidos ao vetor "arquivos_ambiente"

		para(inteiro i = 0; i < 7; i++){
				se(arquivos_ambiente[i] == "-rw------- daemon root 256B gate_0" + fase + ".key"){
					chave_listada = verdadeiro
				}senao se(arquivos_ambiente[i] == "-rw-r--r-- daemon root 4.0K rock.dat"){
					rocha_listada = verdadeiro
				}
			}

		//atribui o valor "gate_0(fase).key" ao vetor "arquivos_ambiente" caso as condições dos comandos "se" sejam verdadeiras
		
		se(possui_chave[fase] != 1 e nao chave_listada){
			para(inteiro i = 0; i < 7; i++){
				se(arquivos_ambiente[i] == ""){
					arquivos_ambiente[i] = "-rw------- daemon root 256B gate_0" + fase + ".key"
					n_arquivos++
					pare
				}
			}
		}

		//atribui o valor "rock.dat" ao vetor "arquivos_ambiente" caso as condições dos comandos "se" sejam verdadeiras
		
		se(fase == 1 e nao rocha_listada){
			para(inteiro i = 0; i < 7; i++){
				se(arquivos_ambiente[i] == ""){
					arquivos_ambiente[i] = "-rw-r--r-- daemon root 4.0K rock.dat"
					n_arquivos++
					pare
				}
			}
		}

		para(inteiro i = 0; i < 7; i++){
			GLOBAL_arquivos_ambiente[i] = arquivos_ambiente[i]
		}

		//escreve os itens que corresponde a listagem de arquivos no ambiente
		
		escreva("\ntotal ", n_arquivos, "\n")
		para(inteiro i = 0; i < 7; i++){
			se(arquivos_ambiente[i] != ""){
				escreva("\n", arquivos_ambiente[i], "\n")
			}
		}
		abrir_terminal()
	}
		}
	}

	funcao inteiro rodar_dado(){
		inteiro numero_sorteado = u.sorteia(1, 20)
		cadeia numero_mostrado
		se(numero_sorteado < 10){
			numero_mostrado = "0" + numero_sorteado
		}senao{
			numero_mostrado = numero_sorteado + ""
		}

		limpa()

		u.aguarde(500)

		limpa()
		escreva("O número sorteado é.\n\n┌──────────┐\n")
		escreva("│          │\n")
		escreva("│    04    │\n")
		escreva("│          │\n")
		escreva("└──────────┘")

		u.aguarde(500)

		limpa()
		escreva("O número sorteado é..\n\n┌──────────┐\n")
		escreva("│          │\n")
		escreva("│    17    │\n")
		escreva("│          │\n")
		escreva("└──────────┘")

		u.aguarde(500)

		limpa()
		escreva("O número sorteado é...\n\n┌──────────┐\n")
		escreva("│          │\n")
		escreva("│    09    │\n")
		escreva("│          │\n")
		escreva("└──────────┘")

		u.aguarde(500)
		limpa()

		para(inteiro i = 0; i < 4; i++){

			escreva("O número sorteado é:\n\n┌──────────┐\n")
			escreva("│          │\n")
			escreva("│    ", numero_mostrado, "    │\n")
			escreva("│          │\n")
			escreva("└──────────┘")
			u.aguarde(500)
			limpa()
			u.aguarde(200)
		}

		retorne numero_sorteado
	}

	funcao combate(){
		cadeia escolha_
		
          inteiro valorDado = rodar_dado()
		u.aguarde(u.sorteia(300, 700))
		
		escreva("┌─────────────────────────────────────────────────────────────┐\n")
		escreva("│ Terminal Quest — Combat Session                             │\n")
		escreva("├─────────────────────────────────────────────────────────────┤\n")
		escreva("│ TARGET : daemon_corrompido                                  │\n")
		escreva("│ PID    : 0347                                               │\n")
		escreva("│ STATUS : HOSTIL                                             │\n")
		escreva("└─────────────────────────────────────────────────────────────┘\n\n")

		u.aguarde(u.sorteia(300, 700))
		
		escreva("┌─ USER STATUS ───────────────────────────────────────────────┐\n")
		escreva("│ INTEGRIDADE   [")

		para(inteiro i = 0; i < (integridade / bits) * 10; i++){
			escreva("█")
		}
		para(inteiro i = 0; i < 5 - (integridade / bits) * 10; i++){
			escreva("░")
		}
		
		escreva("]  ", bits, "/", integridade, " BITS                    │\n")
		escreva("│ KERNEL V.", versao,  "                                                │\n")
		escreva("│ WEAPON: 0 & 1                                               │\n")
		escreva("└─────────────────────────────────────────────────────────────┘\n\n")

		u.aguarde(u.sorteia(300, 700))
		
		escreva("┌─ ENEMY STATUS ──────────────────────────────────────────────┐\n")
		escreva("│ HP   [█████░░░░░]  27/50                                    │\n")
		escreva("│ BUFFER: instável                                            │\n")
		escreva("└─────────────────────────────────────────────────────────────┘\n\n")

		u.aguarde(u.sorteia(300, 700))
		
		escreva("┌─ COMMANDS ──────────────────────────────────────────────────┐\n")
		escreva("│ attack    weapon    daemon                                  │\n")
		escreva("│     scan      escape                                  │\n")
		escreva("└─────────────────────────────────────────────────────────────┘\n\n")
		
		escreva("> ") leia(escolha_)
	}
}
