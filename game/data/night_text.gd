class_name NightText
extends RefCounted
## Textos de ch07_night (docs/09). Definição imutável; PT-BR.
## Redação [O] de conteúdo [C] do capítulo IV do conto, salvo marcação contrária.

const CHAPTER_CARD := "VII — A Noite de Innsmouth\n\nInnsmouth — 16 de julho, 2h"
const END_CARD := "Fim do capítulo VII"

const OBJECTIVES: Dictionary = {
	"washington": "Rumo ao sul pela Washington, longe da praça.",
	"bates": "Passos na Bates. Esconder-se num vestíbulo até passarem.",
	"crossing": "Atravessar o espaço aberto da South sem chamar atenção.",
	"hide_portal": "A estrada do sul está bloqueada. Esconder-se num portal escuro e pensar.",
	"plan": "Consultar o mapa à lanterna, dentro do portal.",
	"babson": "A velha ferrovia de Rowley. Pela Babson até a Lafayette, rente às casas.",
	"lafayette": "Contornar o espaço aberto e subir a Lafayette até a South.",
	"south2": "Atravessar de novo a South, ao luar, com o passo arrastado deles.",
	"adams": "Pela Bates para oeste, depois a Adams até o desfiladeiro.",
	"bank": "Bank Street, junto ao desfiladeiro, até a estação em ruínas.",
	"tracks": "Seguir os trilhos pela beira do desfiladeiro até a ponte coberta.",
	"bridge": "Atravessar a ponte coberta.",
	"marsh": "Seguir os trilhos pelo pântano, escondido no mato.",
	"cut": "Algo vem pela estrada de Rowley. Agachar no mato do corte e esperar que passe.",
	"procession": "Não olhar.",
}

const HINTS: Dictionary = {
	"washington": ["Sul é para onde a rua desce, longe do Gilman.", "Siga a Washington; nenhuma luz pública acesa.", "Ande pela Washington no sentido sul até a esquina da Bates."],
	"bates": ["Há portas fundas nas fachadas.", "Um vestíbulo escuro do lado oeste da Washington, antes da Bates.", "Entre no vão da porta e fique parado até as figuras passarem."],
	"crossing": ["O espaço aberto é banhado de luar.", "Correr chama atenção. Eles andam arrastando os pés.", "Segure o andar arrastado ao atravessar."],
	"hide_portal": ["Saia da praça; siga a Washington para o sul.", "Há um portal escuro no lado oeste, logo depois da praça.", "Entre no portal profundo à direita de quem desce a Washington."],
	"plan": ["O mapa está no bolso.", "Dentro do portal a lanterna não será vista.", "Interaja com o fundo do portal para consultar o mapa."],
	"babson": ["A Babson cruza a Washington mais ao sul.", "Rente às casas; há dois portais pelo caminho.", "Vire à direita na Babson e espere nos portais se ouvir motor."],
	"lafayette": ["O espaço aberto da Eliot fica à frente.", "Não atravesse o meio dele; contorne pela borda norte.", "Vire à direita na Lafayette e suba até a South."],
	"south2": ["A South é larga e iluminada.", "Um bando vem pela Washington, a uma quadra.", "Atravesse segurando o andar arrastado; não corra nem acenda a lanterna."],
	"adams": ["Siga a Bates para oeste.", "A Adams sobe para o norte, rumo ao rugido das quedas.", "Na Adams, siga para o norte até a Bank Street."],
	"bank": ["O rugido das quedas abafa seus passos.", "A estação fica no fim da Bank Street, a oeste.", "Siga a Bank Street para oeste até as arcadas."],
	"tracks": ["Os trilhos partem do fundo da estação.", "Eles seguem a beira do desfiladeiro e viram para o norte.", "Siga os trilhos até a ponte coberta."],
	"bridge": ["Aqui dentro a lanterna não será vista.", "Há um vão nos dormentes, no meio da ponte.", "Acenda a lanterna e interaja na beira do vão para saltar."],
	"marsh": ["Os trilhos seguem para noroeste sobre o aterro.", "O mato esconde você da estrada de Rowley.", "Siga os trilhos até o corte entre barrancos."],
	"cut": ["Esconda-se onde o corte termina.", "Agache-se no mato junto ao fim do corte.", "Fique agachado no fim do corte."],
	"procession": ["Segure para manter os olhos fechados.", "Ninguém o verá aqui.", "Não há como evitar ver."],
}

const NOTES: Dictionary = {
	"plan": "Não me seguem: cumprem um plano para fechar as saídas. Todas as estradas devem estar vigiadas. Resta a ferrovia abandonada para Rowley.",
	"signals": "Clarões no recife — e, da cúpula do Gilman, uma resposta com outro intervalo.",
	"swimmers": "Entre o recife e a praia, o mar fervilha de nadadores rumo à cidade.",
	"ipswich": "Um grupo guarda a estrada de Ipswich. Uma figura de diadema andava quase aos saltos.",
	"band": "O bando do pátio passou a uma quadra. Rostos bestiais. Não sei se me viram.",
	"column": "Ao sul, na estrada de Ipswich, uma coluna que ondula e brilha demais.",
	"procession": "Vi o que não quero escrever. As formas da tiara, vivas.",
}

const THOUGHTS: Dictionary = {
	"start": "Para o sul, pela Washington. Muitos portais desertos onde me abrigar.",
	"bates_warn": "Passos à frente, na Bates — um vestíbulo, depressa.",
	"bates_ok": "Passaram sem me ver.",
	"open_space": "No mapa do rapaz este espaço parecia perigoso: o luar bate em cheio. Atravessar como eles andam.",
	"signals": "Clarões no recife distante. E da cúpula do Gilman, atrás de mim, um sinal que responde.",
	"swimmers": "O mar entre o recife e a praia não está vazio. Cabeças, braços... nadando para cá.",
	"run": "Corri, desatinado — e à esquerda, um clamor de perseguição. Um motor desce a Federal.",
	"portal": "Não me seguiram: obedecem a um plano para cortar a fuga. Todas as estradas devem estar vigiadas...",
	"plan": "A velha ferrovia para Rowley. Babson, Lafayette, Bates, Adams, Bank Street — até a estação.",
	"ipswich": "O grupo que guarda a estrada de Ipswich. Uma das figuras quase salta ao andar.",
	"stragglers": "Atravessar a Eliot depressa, antes que venham retardatários.",
	"rowboat": "Um bote rema para os cais com uma carga volumosa sob a lona. No recife, agora, um brilho fixo de uma cor que não sei dizer.",
	"band": "O bando da Washington, a uma quadra. Algumas cabeças se viram para cá. Não mudar o passo.",
	"band_ok": "Seguiram sem mudar o rumo. Até hoje não sei se me viram.",
	"drunk": "Um homem cambaleia para fora de uma porta escura — bêbado demais para ser ameaça.",
	"bank": "O rugido das quedas engole meus passos. Os armazéns são mais terríveis que as casas.",
	"station": "A estação em arcadas. Os trilhos estão enferrujados, metade dos dormentes podres.",
	"bridge": "A ponte coberta. Aqui dentro posso usar a lanterna.",
	"bats": "Morcegos — uma nuvem deles!",
	"gap": "Um vão nos dormentes. Teria de saltar.",
	"gap_ok": "Do outro lado. O luar de novo.",
	"marsh": "Menos cheiro de peixe. Mato e espinheiros rasgam minha roupa, mas me escondem.",
	"look_back": "Olho para trás: as torres e os telhados de Innsmouth, belos e etéreos sob a lua amarela...",
	"column": "...e ao sul, na estrada de Ipswich, algo ondula. Uma coluna que reluz demais.",
	"wind": "O vento virou para leste. O cheiro voltou — e sons guturais vindos daquele lado.",
	"cut": "Algo vem pela estrada de Rowley. Ficar abaixado até que passe.",
	"close": "Fechar os olhos. Não olhar.",
	"forced": "É claro que a resolução de manter os olhos fechados falhou.",
	"see": "Coaxando, latindo, saltando sob a lua — e alguns usavam tiaras daquele metal sem nome.",
	"leader": "O que vinha à frente usava um casaco preto deformado por uma corcunda, calças listradas e um chapéu de feltro...",
	"faint": "Eram os peixes-rãs blasfemos do desenho da tiara — vivos.",
	"caught_text": "Lanternas, mãos frias, coaxar. Eles o alcançaram.",
}

const DOCS: Dictionary = {}

const FAIL: Dictionary = {
	"CAPTURE": "Eles o alcançaram na noite de Innsmouth.",
	"FALL_GAP": "Os dormentes podres cederam sob o seu passo.",
	"FALL": "Você caiu no desfiladeiro.",
}
