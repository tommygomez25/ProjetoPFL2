# PFL - TP2
### Grupo: SkiJumps_6
### Trabalho realizado por:
 - João Francisco Ferreira Maldonado - up202004244 (50%)
 - Tomás Pereira Matos Gomes - up202004393 (50%)
 
 ### Instalação e execução
 > Para a utilização do jogo, além da instalação do SICStus Prolog 4.7.1, é necessário consultar o ficheiro 'main.pl'.
 > De seguida, para começar o jogo, apenas necessitamos invocar o predicado 'play/0'.

### Descrição Sumária
> Ski Jumps é um jogo de tabuleiro que simula a modalidade de saltos de ski. 
> O objetivo do jogo é sermos o último jogador a mover-se. Para tal, ambos os jogadores jogam à vez, podendo mover as peças horizontalmente o número de casas que desejarem. As peças vermelhas andam para a direita e as pretas para a esquerda. Apenas as peças 'red_jumper' e 'black_jumper' podem andar verticalmente, sendo que podem saltar por cima de uma peça adjacente desde que haja uma casa vazia imediatamente abaixo ou acima (consoante a direção do salto). Ao saltar por cima de uma peça esta passa a ser do tipo 'slipper', mantendo a cor.
> Fontes: https://www.di.fc.ul.pt/~jpn/gv/skijump.htm, https://annarchive.com/files/Winning%20Ways%20for%20Your%20Mathematical%20Plays%20V1.pdf (págs. 28 e 29)

### Representação interna
> A representação interna do tabuleiro é feita através de uma lista de listas, onde cada elemento representa uma posição do tabuleiro. As peças são representadas por símbolos, como 'red' para os 'slippers' vermelhos, 'black' para os 'slippers pretos, 'red_jumper' para os saltadores vermelhos e 'black_jumper' para os saltadores pretos. O símbolo 'empty' é usado para representar posições vazias no tabuleiro.
> Para representar o jogador atual é utilizado o predicado 'current_player/1'. Para alternar este predicado é feito o retract e o assert do mesmo com os valores que o 'Player' pode tomar (red ou black). 
> #### Initial state 
>``` [[red_jumper, empty, empty, empty, empty, empty, empty, empty, empty, empty],[empty, empty, empty, empty,empty,empty, empty, empty, empty, black_jumper],[red_jumper, empty, empty, empty, empty, empty, empty, empty, empty, empty],[empty, empty, empty, empty,empty, empty, empty, empty, empty,black_jumper],[red_jumper, empty, empty, empty, empty, empty, empty, empty, empty, empty],[empty, empty, empty, empty, empty, empty, empty, empty, empty, black_jumper],[red_jumper, empty, empty, empty, empty, empty, empty, empty, empty, empty],[empty, empty, empty, empty, empty, empty, empty, empty, empty, black_jumper],[red_jumper, empty, empty, empty, empty, empty, empty, empty, empty,empty],[empty, empty, empty, empty, empty, empty, empty, empty, empty, black_jumper]]  ``` 



>  #### Intermediate state 
>  ``` [[empty, empty, empty, empty, red_jumper, empty, empty, empty, empty, empty],[empty, empty, empty, empty,empty,empty, empty, empty, empty, black_jumper],[empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],[empty, empty, empty, empty,empty, black, empty, empty, empty,empty],[empty, empty, red_jumper, empty, empty, red_jumper, empty, empty, empty, empty],[empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],[red_jumper, empty, empty, empty, empty, empty, empty, empty, empty, empty],[empty, empty, empty, empty, empty, black_jumper, empty, empty, empty, empty],[empty, empty, red_jumper, empty, empty, empty, empty, empty, empty,empty],[empty, empty, empty, empty, empty, black_jumper, empty, empty, empty, empty]] ``` 

> #### Final state
> ``` [[w-e,b-w,w-e,b-e,w-e,b-e,w-e,b-b,w-e,b-e,w-e], [b-w,w-e,b-e,w-e,b-e,w-e,b-e,w-e,b-e,w-e,b-e], [w-w,b-w,w-e,b-e,w-e,b-e,w-b,b-e,w-e,b-e,w-e], [b-w,w-e,b-e,w-e,b-b,w-e,b-e,w-e,b-b,w-e,b-b], [w-w,b-e,w-e,b-b,w-e,b-e,w-e,b-e,w-e,b-e,w-e], [b-w,w-e,b-e,w-e,b-e,w-e,b-e,w-e,b-e,w-e,b-e], [w-e,b-e,w-e,b-e,w-e,b-e,w-e,b-e,w-e,b-e,w-e], [b-w,w-e,b-e,w-e,b-e,w-e,b-e,w-e,b-e,w-e,b-e], [w-e,b-e,w-e,b-e,w-e,b-b,w-e,b-e,w-e,b-e,w-e], [b-w,w-e,b-e,w-e,b-e,w-e,b-e,w-e,b-e,w-e,b-e], [w-e,b-b,w-e,b-e,w-e,b-e,w-e,b-e,w-e,b-e,w-b]],w ``` 
> ![Final State](./img/finalState.png) 
