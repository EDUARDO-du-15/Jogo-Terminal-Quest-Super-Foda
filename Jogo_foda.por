programa
{
	inclua biblioteca Texto --> txt
	inclua biblioteca Util --> u
	
	cadeia matriz[8][12], direcao = "d", Item = "Nenhum", pos_caixa, GLOBAL_opcao
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

	inteiro y = 4, x = 1, anterior_x = 0, anterior_y = 4, fase = 0, x_chave, y_chave, x_caixa[3], y_caixa[3], aux, caixa_movidax, caixa_moviday, possui_chave[5]
	logico perdeu = falso, porta_saida = falso, porta_entrada = falso, segurando_caixa = falso



	funcao inicio(){

		inteiro pularDialogo = 1
		
		terminalQuest()
		
		se(pularDialogo == 2){
		fala_inicial()
		}
		
		menu()
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
		escreva("== Colete a chave (+) para passsar de nível ==\n")
		escreva("          ====  Fase ", fase, "  ====\n\n")
		para(inteiro i = 0; i < 8; i++){
			escreva("   ")
		para(inteiro j = 0; j < 12; j++){
			escreva(matriz[i][j], "  ")
		}
		se(i == 7){
			escreva("Item selecionado: ", Item)
		}
			escreva("\n")
		}
	}

	funcao movimentacao(){
  
		escreva("Movimentação: ")
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
			}
		}senao se(direcao == "w" e y > 1 e nao validacao_caixa(x, y - 1)){
			anterior_x = x
			anterior_y = y
			y--
		}senao se(direcao == "s" e y < 6 e nao validacao_caixa(x, y + 1)){
			anterior_x = x
			anterior_y = y
			y++
		}senao se(direcao == "1"){
			fase = 1
		}senao se(direcao == " "){
			segurando_caixa = verdadeiro
			anterior_x = 1
			anterior_y = 2
		}
		se(x == x_chave e y == y_chave){
			possui_chave[fase] = 1
			mover_caixa()
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
		escreva("\n\nPressione qualquer tecla: ")
		leia(passar_dialogo)
	}

	funcao mover_caixa(){
		se(caixa_perto()){
			Item = "caixa"
		}
	}
	
	funcao terminalQuest(){
		cadeia passar_dialogo
		escrevaTerminal()
			u.aguarde(1000)
			limpa()
		escrevaQuest(1)
			u.aguarde(1000)
			limpa()
		escrevaTerminal()
		escrevaQuest(2)
		escreva("PRESSIONE ENTER PARA CONTINUAR: ")
		leia(passar_dialogo)
		limpa()
	}
	
	funcao menu(){
		escreva("/===========================================\\ \n")
		escreva("||                                         ||     OQUE DESEJA FAZER?\n")
		escreva("||                                         ||\n")
		escreva("||                                         ||\n")
		escreva("||                                         ||     > boot;\n")
		escreva("||   01101101  01100101 01101110 01110101  ||\n")
		escreva("||    .-.-.-.   .---.   .-..-.   .-..-.    ||     > cat inventory;\n")
		escreva("||    | | | |   | |-    | .` |   | || |    ||\n")
		escreva("||    `-'-'-'   `---'   `-'`-'   `----'    ||     > ls;\n")
		escreva("||                                         ||\n")
		escreva("||                                         ||     > help;\n")
		escreva("||                                         ||\n")
		escreva("||                                         ||     > logout;\n")
		escreva("\\===========================================/\n")

		escreva("\naluno.lab@PC-16930000:~$: ")
		leia(GLOBAL_opcao)
		
		se(GLOBAL_opcao == "boot")			{chameJogo()}
		senao
		se(GLOBAL_opcao == "cat inventory")	{chameJogo()}
		senao
		se(GLOBAL_opcao == "ls")				{chameJogo()}
		senao
		se(GLOBAL_opcao == "logout")			{chameJogo()}
		
		senao							{ajude()}
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
		enquanto(nao perdeu){
			define_caractere()
			desenha_matriz()
			movimentacao()
		}
	}
	funcao ajude(){
		cadeia c
		
		limpa()
		escreva("Comandos:\n")
		escreva("\nboot          - Comece a jogar")
		escreva("\ncat inventory - Olhar inventario")
		escreva("\nls            - Olhe o ambiente")
		escreva("\nlogout        - Sair do jogo")
		escreva("\n\n\nComo Jogar:")
		escreva("\n\nwasd para movimentação, confirme com ENTER após cada tecla")
		escreva("\nColete as chaves(+) para abrir as portas e passar de nível.")
		escreva("\n\nPressione ENTER para continuar.")
		leia(c)
		menu()
	}
}
