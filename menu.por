programa
{
	inclua biblioteca Texto --> txt
	inclua biblioteca Util --> u
	
	cadeia matriz[8][12], direcao = "d", itens[30], pos_caixa, GLOBAL_opcao, GLOBAL_inventario[5][6], GLOBAL_arquivos_ambiente[7], arma = "0"
	cadeia habilidade_inimigo
	inteiro integridade_inimigo = 100, bits_inimigo = integridade_inimigo, dano_inimigo, valor_kernels
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
	inteiro x_chave, y_chave, n_itens = 0
	inteiro  possui_chave[5] = {0,0,0,0,0}
	inteiro x_caixa[3], y_caixa[3], caixa_moviday, caixa_movidax
	real versao = 1.0, kernel = 0.0
	real dano = 0
	logico parou_por_algum_motivo = falso, porta_saida = falso, porta_entrada = falso, segurando_caixa = falso, pular_dialogo, inimigoMorto[8][12]



	funcao inicio(){
	
		para(inteiro i = 0; i<8; i++){
			para(inteiro j = 0; j<12; j++){
				inimigoMorto[i][j] = falso
			}
		}
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
				//borda
				se(j == 11 ou j == 0){
					matriz[i][j] = "|"
				}senao se(i == 7 ou i == 0){
					matriz[i][j] = "—"

					//jogador
				}senao se(y == i e x == j){
					matriz[i][j] = "#"
				}senao se(validacao_caixa(j, i)){
					matriz[i][j] = "□"
				
					
				
				//fase0
				}senao se(fase == 0 e i == 1 e j == 7 e possui_chave[fase] == 0){
					se(possui_chave[fase] == 0){
						matriz[i][j] = "+"
						x_chave = j
						y_chave = i
				}senao{
					matriz[i][j] = "."
					}
				}
				
					//fase1
				senao se(fase == 1 e (i == 1 e j == 7)){
					se(possui_chave[fase] == 0 e i == 1 e j == 7){
						matriz[i][j] = "+"
						x_chave = j
						y_chave = i
					}senao{
						matriz[i][j] = "."
					}
				}

					//fase2
				senao se(fase == 2 e (j == 7 ou (i == 4 e j == 4))){
					se(i != 4 e j == 7){
						matriz[i][j] = "|"
					}senao se(i == 4 e j == 7){
						se(nao inimigoMorto[i][j]){
							matriz[i][j] = "$"
						}senao{
							matriz[i][j] = "."
						}
					}senao se(possui_chave[fase] == 0){
						matriz[i][j] = "+"
						x_chave = j
						y_chave = i
					}senao{
						matriz[i][j] = "."
					}
				}
				
						//fase3Montanha

				senao se(fase == 3 e (j > 2 e j < 10) e (i != 4 e i != 3)){
				se(j == 3 ou j == 5 ou j == 7 ou j == 9){
						matriz[i][j] = "|"
					}
				senao se(i == 5 ou i == 2){
					se(nao inimigoMorto[i][j]){
						matriz[i][j] = "$"
					}
				}senao se(possui_chave[fase] != 1){
					matriz[i][j] = "+"
					x_chave = 6
					y_chave = 1
				}senao{
					matriz[i][j] = "."
					}

				//espaco vazio
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
		define_caractere()
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
  		inteiro chanceInimigo = 0
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
				se(nao inimigoMorto[y][x] e ((matriz[y][x] == "$") ou (u.sorteia(1, 20) <=chanceInimigo))){
					combate(verdadeiro)
				}
			}
		}senao se(direcao == "a" e x >= 1){
			se(porta_entrada e (y == 3 ou y == 4) e x == 1){
				fase--
				x = 10
				y = 4
				possui_chave[fase] = 0
				porta_saida = verdadeiro
			}senao se(x > 1 e nao validacao_caixa(x - 1, y)){
				anterior_x = x
				anterior_y = y
				x--
				se(nao inimigoMorto[y][x] e ((matriz[y][x] == "$") ou (u.sorteia(1, 20) <=chanceInimigo))){
					combate(verdadeiro)
				}
			}
		}senao se(direcao == "w" e y > 1 e nao validacao_caixa(x, y - 1)){
			anterior_x = x
			anterior_y = y
			y--
			se(nao inimigoMorto[y][x] e ((matriz[y][x] == "$") ou (u.sorteia(1, 20) <=chanceInimigo))){
					combate(verdadeiro)
			}
		}senao se(direcao == "s" e y < 6 e nao validacao_caixa(x, y + 1)){
			anterior_x = x
			anterior_y = y
			y++
			se(nao inimigoMorto[y][x] e ((matriz[y][x] == "$") ou (u.sorteia(1, 20) <=chanceInimigo))){
					combate(verdadeiro)
			}
		}senao se(direcao == "1"){
			fase++
		}senao se(direcao == "2"){
			fase--
		}senao se(direcao == " "){
			segurando_caixa = verdadeiro
			anterior_x = 1
			anterior_y = 2
			mover_caixa()
		}senao se(direcao == "  "){
			segurando_caixa = falso
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
		escreva("||                                         ||     > cat map.txt;\n")
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

	funcao desenheInimigoBombado(){
		
		cadeia virusBombado[31] = {
"@@@@@@@@@@@@@@@@@@@@@@@@@%#*@@@@*@%*#*#%@@**%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@",
"@@@@@@@@@@@@@@@@@@@@@@@@@@@@##%======++#==*=@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@",
"@@@@@@@@@@%+-...:%@@@##%@@@@%*#*******=+*++==###@@@##@@@-=:-#@@@@@@@@@@@@@",
"@@@@@@@@%...:.-..-@@@@@@%##+=++*#######*##*++=-*##%@@@@:-......+@@@@@@@@@@",
"@@@@@@@%..:++*===#@@@@@@@@%=+***#####%%####**+=-@@@@@@%=+:-.-....-@@@@@@@@",
"@@@@@@*...+@@@@@@@@@@@@#*#===#####%%%%%%###*#++=%@@@@@@@@@@@@@#....@@@@@@@",
"@@@@@:..:.*@@@@@@@@@@@@+=*=++*####%%%%%%####*+*+*##**@@@@@@@@@@*....#@@@@@",
"@@@%:.....+@@@@@@@@@@@@@@@-++**####%%%%###*#*++-###@@@@@@@@@@@@@.....*@@@@",
"@@#:......*@@@@@@@@@@@@@@@#=+***####%%#**#***+=*@@@@@@@@@@@@@@@@......=@@@",
"@%-:......@@@@@@@@@@@@@@###+=+****###**+=*++==+#@@@@@@@@@@@@@@@@:......=@@",
"@+:......*@%=:=%@@@%=+#*@@@@%-*#++*****+#+===%@@##%@@@@@@@@@@@@@=.......#@",
"%-:.....:.:......-........:-:*=====+++*#===:..:-..-*:..:+-....-%*=......+@",
"%-:................-:.....:#+..---=----*+-:*............................=@",
"@@#-........:-:.....::.....:.....==.:..-+..+*:.......=..............:-..-@",
"@@@@@#=::.........--:::..........*...-.+#+..........-::...:...........:#@@",
"@@@@@@@@%*:.......=:..-.........+*...-.............=................#@@@@@",
"@@@@@@@@@@@@@@@@@@@=...-.............:............-...=@@@#*+=+#%@@@@@@@@@",
"@@@@@@@@@@@@@@@@@@@@+...-........................-...-@@@@@@@@@@@@@@@@@@@@",
"@@@@@@@@@@@@@@@@@@@@@#....-..........-.......-:::...:@@@@@@@@@@@@@@@@@@@@@",
"@@@@@@@@@@@@@@@@@@@@@@*....:-........:........=....=@@@@@@@@@@@@@@@@@@@@@@",
"@@@@@@@@@@@@@@@@@@@@@@@=...:....==-=....==+=-.....%@@@@@@@@@@@@@@@@@@@@@@@",
"@@@@@@@@@@@@@@@@@@@@@@@@=.:.:...::.....:=:....:..*@@@@@@@@@@@@@@@@@@@@@@@@",
"@@@@@@@@@@@@@@@@@@@@@@@@@-....-............+..-.%@@@@@@@@@@@@@@@@@@@@@@@@@",
"@@@@@@@@@@@@@@@@@@@@@@@@@@......:==:........-..+@@@@@@@@@@@@@@@@@@@@@@@@@@",
"@@@@@@@@@@@@@@@@@@@@@@@@@@..........:......-...*@@@@@@@@@@@@@@@@@@@@@@@@@@",
"@@@@@@@@@@@@@@@@@@@@@@@@@@-.........-......:...%@@@@@@@@@@@@@@@@@@@@@@@@@@",
"@@@@@@@@@@@@@@@@@@@@@@@@@@:...+:....-......=..:@@@@@@@@@@@@@@@@@@@@@@@@@@@",
"@@@@@@@@@@@@@@@@@@@@@@@@@@....................:@@@@@@@@@@@@@@@@@@@@@@@@@@@",
"@@@@@@@@@@@@@@@@@@@@@@@@@@:..-................=@@@@@@@@@@@@@@@@@@@@@@@@@@@",
"@@@@@@@@@@@@@@@@@@@@@@@@@%:=................=.=@@@@@@@@@@@@@@@@@@@@@@@@@@@",
"@@@@@@@@@@@@@@@@@@@@@@@@@*+=:..:..........:=++*%@@@@@@@@@@@@@@@@@@@@@@@@@@"}
	
		para(inteiro i = 0; i < 31; i++){
			escreva(virusBombado[i], "\n")
		}
	}
	
	funcao chameJogo(){
		enquanto(nao parou_por_algum_motivo){
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

	funcao mostrar_inventario(logico abrirTerminal){

		cadeia sair
		cadeia continuar
		
		escreva("\ntotal ", n_itens, "\n\n")
		
		para(inteiro i = 0; i < 5; i++){
			para(inteiro j = 0; j < 6; j++){
				se(GLOBAL_inventario[i][j] != "."){
					escreva("-rw------- daemon root 1.0K ", GLOBAL_inventario[i][j], "\n")
				}
			}
		}
		se(abrirTerminal){
		abrir_terminal()
	}senao{
		escreva("Press enter to continue: ")
		leia(continuar)
	}
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
		se(comando == "ls -l inv")		{mostrar_inventario(verdadeiro)}
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

	funcao combate(logico comece){
		
		se(comece){
			sorteio_inimigo()
			dano = 1.5
		}
		
		cadeia escolha_
		u.aguarde(u.sorteia(300, 700))

		limpa()
		
		escreva("┌─────────────────────────────────────────────────────────────┐\n")
		escreva("│ Terminal Quest — Combat Session                             │\n")
		escreva("├─────────────────────────────────────────────────────────────┤\n")
		escreva("│ TARGET : daemon_corrompido                                  │\n")
		escreva("│ PID    : 0347                                               │\n")
		escreva("│ STATUS : HOSTIL                                             │\n")
		escreva("│ ATAQUES : ROOTKIT                                           │\n")
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
		escreva("│ HP   [")

		para(inteiro i = 0; i < (integridade_inimigo / bits_inimigo) * 10; i++){
			escreva("█")
		}
		para(inteiro i = 0; i < 5 - (integridade_inimigo / bits_inimigo) * 10; i++){
			escreva("░")
		}

		cadeia integridade_inimigo_texto = integridade_inimigo + ""
		cadeia bits_inimigo_texto = bits_inimigo + ""
		inteiro n_espacos = 6 - txt.numero_caracteres(integridade_inimigo_texto) + txt.numero_caracteres(bits_inimigo_texto)

		escreva("]  ", integridade_inimigo, "/", bits_inimigo, "                            ")
		para(inteiro i=0; i < n_espacos; i++){
			escreva(" ")
		}
		escreva("│\n")
		escreva("│ BUFFER: instável                                            │\n")
		escreva("└─────────────────────────────────────────────────────────────┘\n\n")

		u.aguarde(u.sorteia(300, 700))
		
		escreva("┌─ COMMANDS ──────────────────────────────────────────────────┐\n")
		escreva("│ attack    daemon                                            │\n")
		escreva("│      scan      escape                                       │\n")
		escreva("└─────────────────────────────────────────────────────────────┘\n\n")
		
		escreva("> ") leia(escolha_)
		
		se(escolha_ == "attack"){
			escolher_arma()
			se(arma == "1"){
				bits_inimigo = bits_inimigo - (dano * rodar_dado())
			}senao se(arma == "0"){
				dano += u.sorteia(2, 5) / 10
			}
			se(bits_inimigo <=0){
				inimigoMorto[y][x] = verdadeiro
			}senao{combate(falso)}
		}senao se(escolha_ == "daemon"){
			mostrar_inventario(falso)
		}senao se(escolha_ == "escape"){
			se(rodar_dado() >= 10){
				desenha_matriz()
			}senao{
				se(nao pular_dialogo){
					escreva_lento("Má sorte ein... haha", 70)
					escreva("\n\n     PRESSIONE ENTER PARA CONTINUAR: ")
					leia(pular_dialogo)
				}
				combate(falso)
			}
		}senao{
			combate(falso)
		}
	}

	funcao sorteio_inimigo(){

		inteiro numero_sorteado

		numero_sorteado = u.sorteia(0, 20)
		//inimigo bombado
		se(numero_sorteado >= 18){
			integridade_inimigo = 50
			bits_inimigo = integridade_inimigo
			valor_kernels = 100
			numero_sorteado = u.sorteia(1, 3)
			se(numero_sorteado == 1){
				habilidade_inimigo = "STACK OVERFLOW"
				dano_inimigo = 18
			}senao se(numero_sorteado == 2){
				habilidade_inimigo = "KERNEL PANIC"
				dano_inimigo = 10
			}senao{
				habilidade_inimigo = "ROOTKIT"
				dano_inimigo = 18
			}
		}senao se(numero_sorteado >= 15){
			valor_kernels = 50
			integridade_inimigo = 40
			bits_inimigo = integridade_inimigo
			habilidade_inimigo = "THREAD SPLIT"
			dano_inimigo = 11
		}senao se(numero_sorteado >= 10){
			valor_kernels = 35
			integridade_inimigo = 30
			bits_inimigo = integridade_inimigo
			habilidade_inimigo= "CACHE STRIKE"
			dano_inimigo = 9
		}senao se(numero_sorteado >= 1){
			valor_kernels = 25 
			integridade_inimigo = 20
			bits_inimigo = integridade_inimigo
			habilidade_inimigo = "SCAN"
			dano_inimigo = 7
		}senao{
			valor_kernels = 10
			integridade_inimigo = 20
			bits_inimigo = integridade_inimigo
			habilidade_inimigo = "PING"
			dano_inimigo = 3
		}
	}

	funcao escolher_arma(){
		cadeia passar_dialogo
		arma = "0"
		limpa()
		escreva("========== ESCOLHA A SUA ARMA ==========\n\n")
		escreva("     ----- 0 ----- 1 -----\n\n")
		escreva("A arma zero pode aumentar seus atributos de ataque;\n\nJá ao usar a arma um, você pode atacar o inimigo")
		escreva("\n\nESCOLHA SUA ARMA: ")
		leia(arma)
		se(arma != "0" e arma != "1"){
			escreva("ARMA INVÁLIDA\n\nPRESSIONE ENTER PARA CONTINUAR: ")
			leia(passar_dialogo)
		}
	}
}
