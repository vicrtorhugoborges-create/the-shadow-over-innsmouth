class_name GilmanText
extends RefCounted
## Textos da fatia vertical (ch05–ch06). Definição imutável; PT-BR.
## Redação [O] de conteúdo [C] do capítulo IV do conto, salvo marcação contrária.

const CHAPTER_CARD := "V — A Armadilha\n\nInnsmouth — 15 de julho, 19h50"
const ESCAPE_CARD := "VI — Fuga do Gilman House"

const OBJECTIVES: Dictionary = {
	"square": "O ônibus de Arkham sai às oito. Falar com o motorista.",
	"lobby": "Pedir um quarto no Gilman House.",
	"upstairs": "Subir ao quarto 428.",
	"room": "Passar a noite com a porta trancada.",
	"bed": "Deitar-se vestido e esperar o dia.",
	"listen": "Escutar.",
	"prepare": "Sair do hotel — não pelas escadas nem pelo saguão.",
	"ram": "Arrombar a porta de ligação ao norte.",
	"n1": "Trancar a porta do corredor antes que a chave gire!",
	"n2": "A porta do terceiro quarto está se abrindo: empurrá-la e trancar!",
	"barricade": "Fechar as portas de ligação e barricá-las.",
	"window": "Descer pela janela até o telhado da Paine Street.",
	"roof": "Chegar à claraboia sem escorregar.",
	"attic": "Descer até o térreo e sair longe da Paine Street.",
	"courtyard": "Atravessar o pátio até um prédio do lado da Washington.",
	"hall": "Achar outra saída para a Washington Street.",
	"street": "Rumo ao sul pela Washington.",
}

const HINTS: Dictionary = {
	"square": ["O motorista está ao lado do ônibus.", "Joe Sargent, junto ao para-choque.", "Aproxime-se de Sargent e interaja."],
	"lobby": ["Não há outro transporte. Resta o hotel.", "A entrada do Gilman House fica atrás dos ociosos.", "Entre pelo Gilman e fale com o funcionário no balcão."],
	"upstairs": ["O 428 fica três lances acima, logo abaixo do sótão.", "A escada sobe ao lado do balcão.", "Interaja com o pé da escada."],
	"room": ["A porta do corredor parece diferente.", "Falta o ferrolho na porta; o armário tem um do mesmo tamanho.", "Examine a porta, desaparafuse o ferrolho do armário com a ferramenta do chaveiro e instale-o."],
	"bed": ["Tudo precisa estar trancado antes de deitar.", "A porta do corredor e as duas portas de ligação.", "Corra os três ferrolhos e interaja com a cama."],
	"prepare": ["As janelas mostram por onde fugir; as portas mostram como.", "Só um quarto a duas portas alcança um telhado. Veja para que lado cada porta de ligação abre.", "A porta sul abre na sua direção: bloqueie-a com a cama. A norte abre para longe: será arrombada. Empurre a cômoda contra a porta do corredor."],
	"ram": ["O barulho das batidas encobre o seu.", "A porta de ligação ao norte abre para longe de você.", "Interaja repetidamente com a porta norte (ou segure, se a opção estiver ativa)."],
	"n1": ["A porta do corredor deste quarto.", "O ferrolho fica na porta que dá para o corredor.", "Tranque já a porta do corredor deste quarto."],
	"n2": ["A porta de ligação seguinte está entreaberta.", "Passe ao terceiro quarto e segure a porta que se abre.", "Empurre a porta do corredor do terceiro quarto e tranque."],
	"barricade": ["As duas portas de ligação deste quarto estão abertas.", "Feche e tranque ambas; depois cama, cômoda e lavatório.", "A porta norte primeiro. Depois empurre a cama contra ela."],
	"window": ["A janela mais ao sul tem cortinas pesadas.", "Veludo, varão e argolas de latão — e um gancho de veneziana do lado de fora.", "Arranque as cortinas e use a janela sul para descer."],
	"roof": ["Ardósia solta: devagar.", "A claraboia está na água interna do telhado.", "Ande (sem correr) até a abertura escura e interaja."],
	"attic": ["Há uma escada.", "Desça até o térreo.", "Evite a porta da Paine; use a porta dos fundos."],
	"courtyard": ["Do outro lado do pátio há portas abertas.", "O prédio do lado da Washington.", "Entre pela porta mais próxima e procure a porta da rua."],
	"hall": ["Não volte ao pátio agora.", "Há outra porta neste corredor.", "Abra a porta lateral e procure as venezianas."],
}

const NOTES: Dictionary = {
	"breakdown": "O ônibus não pode seguir para Arkham esta noite. Sargent diz que não há outro transporte.",
	"room": "Quarto 428, nos fundos, penúltimo andar. Um dólar. Sem água corrente.",
	"bolt": "Havia um ferrolho na porta; as marcas mostram que foi retirado há pouco.",
	"tries": "Uma chave tentou a minha fechadura. Depois, os quartos ao norte e ao sul foram abertos e as portas de ligação, testadas.",
	"power": "A luz foi cortada. No andar de baixo, sons que não sei chamar de vozes.",
	"window": "Sem escada de incêndio. Os telhados ao norte e ao sul só se alcançam de um quarto a duas portas do meu.",
	"hinges": "A porta sul abre para o meu lado: não dá para forçá-la. A norte abre para longe: esta eu posso arrombar.",
	"pursuers": "Nenhum deles pronunciou uma palavra inteligível. Só ofegos, grunhidos, latidos abafados.",
	"lights": "Luzes acesas na Ordem de Dagon, na igreja batista e na congregacional.",
	"crowd": "Uma figura entre eles usava uma tiara alta, de desenho familiar demais.",
}

const THOUGHTS: Dictionary = {
	"start": "19h50. O ônibus de Arkham sai às oito.",
	"crowd_door": "Quase todos os ociosos estão junto à porta do Gilman. Olhos saltados, que não piscam.",
	"missing_bolt": "Não há ferrolho. Havia um — as marcas são recentes.",
	"wardrobe": "O armário tem um ferrolho do mesmo tamanho das marcas da porta.",
	"bolt_removed": "Dois parafusos. A ferramenta do chaveiro serve.",
	"bolt_fitted": "Encaixou perfeitamente. Algum símbolo de segurança, ao menos.",
	"need_bolts": "Antes de deitar, quero os três ferrolhos corridos.",
	"flashlight": "A lanterna no bolso da calça, para ver o relógio se acordar no escuro.",
	"window_dusk": "Um pátio sombrio cercado de blocos de tijolo desertos; telhados para oeste; o pântano além.",
	"cant_sleep": "O sono não vem. Percebo que estou escutando — à espera de algo que não sei nomear.",
	"got_up": "Alguém tentou entrar. Tenho de sair deste hotel vivo — e não pela escada da frente.",
	"power_cut": "Lanterna sobre o interruptor: nada. A energia foi cortada.",
	"power_cut_no_light": "O interruptor não responde. A energia foi cortada. A lanterna ficou na valise.",
	"croaks": "Lá embaixo, conversas? Latidos roucos, sílabas frouxas... nada que pareça fala humana.",
	"window_night": "Sem escada de incêndio: três andares até o pátio. À direita e à esquerda, telhados inclinados — a duas portas do meu quarto.",
	"south_door": "A porta sul abre para dentro, na minha direção, e há outras trancas do lado de lá. Não dá para forçá-la.",
	"north_door": "A porta norte abre para longe de mim, trancada do outro lado. Esta cede ao ombro — mas não sem barulho.",
	"ram_early": "Agora o estrondo me denunciaria. Preciso de algo que o encubra.",
	"stairs_no": "Não pela escada. Não pelo saguão.",
	"despair": "Preso num quarto sem saída pela janela...",
	"no_voices": "Nenhum deles diz uma palavra. Só ofegos, grunhidos, latidos abafados.",
	"jump_warning": "O telhado está lá embaixo, mas o salto seria desesperadamente arriscado naquela superfície íngreme.",
	"roof": "Ardósias soltas. Ao norte, por cima das chaminés, luzes na Ordem de Dagon, na igreja batista e na congregacional.",
	"attic": "Uma queda curta. Caixas e barris desfeitos. O relógio marca duas horas.",
	"paine_door": "A porta da Paine Street. O quartel dos bombeiros pode estar aberto a noite toda.",
	"courtyard": "Sem luar aqui embaixo. Algumas janelas do Gilman brilham fracas; ouço confusão lá dentro.",
	"wedged": "A porta da rua está emperrada. Não cede.",
	"crowd": "Saem do Gilman com lanternas, aos montes. Não sabem para onde fui — mas se eu voltar ao pátio, me verão.",
	"shutters": "Venezianas fechadas, sem caixilhos. Abrem por dentro.",
	"outside": "Washington Street. Nenhuma luz além da lua; ao longe, vozes roucas, passos e um tamborilar que não soa bem como passos.",
	"closed_shutter": "Fecho a veneziana como estava.",
	"slip": "As ardósias escorregam sob o pé — devagar!",
}

const SARGENT_LINE := "Problema no motor... apesar da viagem rápida desde Newburyport. Não vai até Arkham hoje. Não tem como consertar à noite, nem outro jeito de sair daqui. O senhor vai ter de passar a noite no Gilman. O funcionário faz um preço camarada."
const CLERK_LINE := "Quarto 428, no penúltimo andar. Grande, mas sem água corrente. Um dólar."
const DINNER_LINE := "Ainda havia luz. Jantei no restaurante da praça — sopa de legumes com bolachas, quase tudo de lata e de pacote — e, de volta, comprei um jornal vespertino e uma revista no balcão do funcionário."

const DOCS: Dictionary = {
	"doc_sketch_map": {
		"title": "Mapa desenhado pelo rapaz da mercearia",
		"body": "[i]Esboço a lápis, rude mas cuidadoso. Muitas placas de rua caíram.[/i]\n\n• [b]Town Square[/b], na margem sul do Manuxet; o Gilman House no lado oeste, de frente para a praça.\n• Ao norte do hotel, a [b]Paine Street[/b] (quartel dos bombeiros).\n• Para o sul: [b]Washington[/b] e, paralela, a [b]Federal[/b]. Mais abaixo, Bates; a praça onde a Eliot cruza a Washington e a South — [i]espaço aberto, sem abrigo[/i].\n• A [b]Eliot[/b] segue oblíqua até virar a estrada de Ipswich. A estrada para Arkham sai pelo sul.\n• A oeste, à beira do desfiladeiro, a [b]Bank Street[/b] e a velha estação; os trilhos abandonados seguem para Rowley.\n\n[i]Anotação do rapaz:[/i] a melhor saída da cidade é para o sul.",
	},
	"doc_zadok_record": {
		"title": "O que Zadok Allen contou (anotação)",
		"body": "[i]Registrado de memória, à tarde, no cais em ruínas.[/i]\n\nUm velho de noventa e seis anos, bêbado de uísque, falou do capitão Obed Marsh, das ilhas do Pacífico, de um pacto com coisas que vivem sob o mar, do ouro da refinaria, de 1846 e dos juramentos de Dagon. Falou de uma filha de Obed casada com um homem de Arkham por um truque, e de olhos como os de Obed.\n\nNo fim, olhou para o mar, gritou e fugiu: \"Eles nos viram.\"\n\nDelírio de bêbado, sem dúvida. Ainda assim, não consigo tirar da cabeça os olhos dele.",
	},
	"doc_evening_paper": {
		"title": "Jornal vespertino",
		"body": "[i]Edição de Newburyport, manchada de dedos.[/i]\n\nTEMPO — Quente e claro em todo o condado de Essex; lua quase cheia esta noite.\n\nPESCA — Preços do bacalhau e da lagosta voltam a cair; os pescadores de Gloucester reclamam da concorrência das grandes companhias.\n\nLEI SECA — Agentes apreendem carga de bebida num galpão perto de Ipswich.\n\nNOTAS SOCIAIS — Excursão da Sociedade Histórica de Newburyport a Salem no próximo sábado.\n\n[i]Leio duas vezes o mesmo parágrafo sem guardar uma palavra.[/i]",
	},
}

const FAIL: Dictionary = {
	"F1": "A porta do corredor cedeu. Lanternas no quarto.",
	"F2": "A chave girou antes do ferrolho.",
	"F3": "A porta do terceiro quarto se abriu.",
	"F4": "A porta de ligação cedeu antes que você descesse.",
	"F5": "As ardósias soltas não seguraram o salto.",
	"F6": "As lanternas o encontraram no pátio.",
	"FALL": "Você escorregou do telhado.",
}
