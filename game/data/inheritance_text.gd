class_name InheritanceText
extends RefCounted
## Textos de ch08_inheritance (docs/04 §10). Definição imutável; PT-BR.
## Redação [O] de conteúdo [C] do capítulo V do conto, salvo marcação contrária.
## Nada aqui é tradução moderna publicada: paráfrases e tradução própria do texto de 1936.

const CARDS: Dictionary = {
	"rain": "VIII — A Herança de Innsmouth\n\n16 de julho de 1927, passa do meio-dia",
	"arkham": "Arkham, 17 de julho de 1927",
	"society": "Sociedade Histórica de Arkham",
	"oberlin": "Oberlin, Ohio — fevereiro de 1928",
	"cleveland": "Cleveland — meados de julho de 1928",
	"vault": "Um cofre no centro de Cleveland",
	"years": "Dois anos num escritório de seguros. A rotina como esconderijo.",
	"dreams": "Toledo — inverno de 1930–31",
	"final": "Mais tarde",
}

const OBJECTIVES: Dictionary = {
	"rain": "Sair do corte e chegar à estrada de Rowley.",
	"interview": "Relatar o que vi ao funcionário do governo.",
	"society": "Consultar o curador sobre a família de minha mãe.",
	"oberlin": "Ler o que os jornais disseram.",
	"cleveland": "Examinar os arquivos Orne do tio Walter e montar o quadro da família.",
	"vault": "Ver o que havia na caixa de minha bisavó.",
	"night": "Dormir.",
	"wake": "Acordar.",
	"dream": "…",
	"mirror": "O espelho.",
	"final": "Escrever as últimas páginas.",
	"swim": "Nadaremos até aquele recife no mar.",
}

const HINTS: Dictionary = {
	"rain": ["A estrada fica adiante, onde o corte termina.", "Siga os trilhos para o norte até a estrada.", "Ande até a placa de Rowley e interaja."],
	"interview": ["O funcionário espera à mesa.", "Fale com ele e conte cada parte.", "Interaja com o funcionário e escolha os quatro relatos."],
	"society": ["O curador está junto às estantes.", "Diga a ele de quem você é neto.", "Fale com Peabody até o fim."],
	"oberlin": ["Os recortes estão sobre a escrivaninha.", "Leia os recortes de fevereiro.", "Interaja com os recortes."],
	"cleveland": ["Fotos, cartas e uma miniatura estão sobre a mesa; o quadro fica na parede.", "Cada documento lido libera fichas para o quadro.", "Leia tudo na mesa e encaixe as fichas: avó, tio, bisavô, bisavó, os pais dela, o outro filho."],
	"vault": ["Walter hesita.", "Peça que continue.", "Fale com Walter e escolha continuar."],
	"night": ["A cama fica junto à parede.", "Deite-se.", "Interaja com a cama."],
	"dream": ["Não há perigo aqui.", "Siga adiante.", "Caminhe para onde as luzes chamam."],
	"mirror": ["Algo mudou no quarto.", "O pano caiu do espelho.", "Aproxime-se do espelho."],
	"final": ["O manuscrito está na escrivaninha.", "Escreva as últimas páginas.", "Interaja com o manuscrito e assine."],
	"swim": ["O recife está à frente.", "Nadaremos.", "Segure para seguir."],
}

const NOTES: Dictionary = {
	"no_prints": "Lama fresca na estrada, e nenhuma pegada. O cheiro de peixe tinha sumido.",
	"testimony": "Contei tudo ao governo em Arkham — e depois em Boston.",
	"peabody": "Peabody: minha bisavó era uma Marsh de New Hampshire, educada na França; pais que ninguém localiza; morreu ao dar à luz minha avó, em 1867.",
	"eyes": "Peabody disse que eu tenho os verdadeiros olhos Marsh.",
	"raids": "Fevereiro de 1928: batidas, prisões sem julgamento, casas dinamitadas na orla de Innsmouth.",
	"photos": "Os rostos da avó e do tio Douglas sugerem agora algo que não sugeriam antes.",
	"chart": "O quadro está completo. Coincidências, digo a mim mesmo.",
	"question": "Seria Obed Marsh meu tataravô? E quem — ou o quê — foi minha tataravó?",
	"vault": "Dois braceletes, um peitoral e uma tiara. Desmaiei, como no corte de mato um ano antes.",
	"dreams": "Os sonhos começaram no inverno de 1930–31. Neles eu não sentia horror.",
	"mirror": "O espelho confirmou: adquiri a aparência de Innsmouth.",
}

const THOUGHTS: Dictionary = {
	"rain": "Uma chuva leve me acordou. O corpo inteiro dói.",
	"no_prints": "Lama fresca na estrada — e nenhuma pegada. O cheiro de peixe sumiu.",
	"town": "A sudeste, os telhados de Innsmouth, cinzentos. Nenhuma criatura viva em todo o pântano.",
	"watch": "O relógio ainda anda: passa do meio-dia.",
	"rowley": "Rowley. Uma refeição, roupas apresentáveis, o trem noturno para Arkham.",
	"museum": "Não ousei procurar a peça do museu da Miskatonic.",
	"knock": "Batem à porta: mais uma visita oficial, por causa da campanha que meus apelos começaram.",
	"photo_again": "Olho de novo. A expressão sugere agora algo que não sugeria antes — algo que traria pânico se eu pensasse nele abertamente.",
	"refuse": "Coincidências. Uma moça de New Hampshire e a história de um bêbado.",
	"father": "Meu pai, na porta, olhando para mim com algo que parece medo.",
	"hands_dream": "Minhas mãos têm membranas. Isso não me assusta.",
	"wake1": "Acordei com horror. Não lembro de tudo.",
	"wake2": "Minha mão real é só uma mão. Por enquanto.",
	"wake3": "Acordei gritando.",
	"drawer": "A automática. Comprei-a e quase dei o passo; certos sonhos me detiveram.",
	"mirror": "…",
	"sign": "Assino.",
}

const INTERVIEW_INTRO := "Sente-se. Conte o que viu em Innsmouth, na ordem que preferir. Tudo."
const INTERVIEW_TOPICS: Dictionary = {
	"told_zadok": ["O velho Zadok Allen", "Contei as histórias de Zadok: o capitão Obed, as ilhas, o ouro, 1846, os juramentos. E como ele fugiu gritando."],
	"told_hotel": ["A noite no Gilman House", "Contei sobre a chave na fechadura, os quartos invadidos, as vozes que não eram vozes."],
	"told_signals": ["Os sinais do recife", "Contei sobre os clarões em Devil Reef, a resposta da cúpula do Gilman, o mar cheio de nadadores."],
	"told_procession": ["A coisa na estrada de Rowley", "Contei o que vi na estrada. Ou o que acredito ter visto."],
}
const INTERVIEW_END := "O senhor fará o mesmo relato em Boston. E não fale com jornalistas."

const PEABODY: Array = [
	["E. Lapham Peabody", "Em que posso ajudá-lo, rapaz?", ["Sou neto de Eliza Orne, nascida em Arkham em 1867."]],
	["E. Lapham Peabody", "Orne! Então o senhor é parente daquele moço que esteve aqui há muitos anos, com a mesma curiosidade. Um tio seu, creio. A família de sua avó deu o que falar por aqui.", ["Deu o que falar?"]],
	["E. Lapham Peabody", "O casamento do pai dela, Benjamin Orne, logo depois da Guerra Civil. A noiva era tida como uma Marsh órfã de New Hampshire — prima dos Marsh do condado de Essex —, mas fora educada na França e sabia muito pouco da própria família.", ["E quem cuidava dela?"]],
	["E. Lapham Peabody", "Um tutor depositou fundos num banco de Boston para mantê-la e à governanta francesa. Ninguém em Arkham conhecia o nome dele, que acabou sumindo; a governanta assumiu a tutela por nomeação judicial. Uma mulher muito calada. Diziam que poderia ter contado mais.", ["E os pais dela?"]],
	["E. Lapham Peabody", "Eis o mistério: ninguém conseguiu situar os pais registrados — Enoch e Lydia Meserve Marsh — entre as famílias conhecidas de New Hampshire. Talvez fosse filha natural de algum Marsh importante. Morreu cedo, ao dar à luz sua avó, a única filha.", ["Algo mais?"]],
	["E. Lapham Peabody", "Tinha os verdadeiros olhos Marsh, diziam. E — perdoe-me — o senhor também os tem.", ["…Obrigado. Posso copiar suas notas?"]],
]

const WALTER_FILES := "Pode olhar tudo: cartas, recortes, fotografias, miniaturas. Os papéis da família Orne estão comigo desde que sua avó… desapareceu."
const WALTER_CHART_DONE := "Há também uma caixa no banco, umas peças antigas de sua bisavó. Sua avó gostava de olhar para elas. Quer ver?"
const VAULT_LINES: Array = [
	["Tio Walter", "Não se assuste com os desenhos. São estranhos, às vezes horríveis. Artistas que os viram dizem que o trabalho é de uma finura extraordinária, mas ninguém sabe dizer o metal nem a tradição.", ["Pode abrir."]],
	["Tio Walter", "Dois braceletes. Um peitoral… estes relevos. Você está pálido. Quer que eu pare?", ["Continue."]],
	["Tio Walter", "E esta. Sua avó gostava de olhar para ela mais que para todas.", ["…"]],
]

const DREAM_GRANDMOTHER: Array = [
	["Avó", "Você veio. Eu sabia que viria.", ["Vovó? A senhora morreu."]],
	["Avó", "Eu nunca morri. Fui para o lugar de que seu tio Douglas tinha ouvido falar — o reino que ele recusou com uma pistola fumegante. Era dele também. É seu.", ["Que lugar é este?"]],
	["Avó", "Y'ha-nthlei. Ferida quando os homens da superfície atiraram a morte no mar, mas não destruída. Os Profundos nunca serão destruídos. Por ora, descansam. Um dia, se lembrarem, voltarão a subir.", ["E quem é aquela?"]],
	["Avó", "E esta é minha avó, Pth'thya-l'yi. Viveu aqui oitenta mil anos e voltou depois que Obed Marsh morreu. Pelo mal que trouxe aos que vivem aqui, você fará uma penitência. Não será pesada. Você não vai morrer.", ["…"]],
]

const FINAL_PAGES := "[i]Últimas páginas do manuscrito.[/i]\n\nAté agora não me matei, como fez meu tio Douglas. Comprei uma automática e quase dei o passo, mas certos sonhos me detiveram. Os extremos do horror estão diminuindo; sinto-me atraído pelas profundezas do mar, em vez de temê-las. Ouço e faço coisas estranhas no sono e acordo com uma espécie de exaltação, não de terror.\n\nNão creio que precise esperar a mudança completa, como a maioria esperou. Se eu esperasse, meu pai provavelmente me trancaria num sanatório, como trancaram meu pobre primo. Esplendores inauditos me aguardam lá embaixo, e irei buscá-los em breve.\n\nNão, não vou me matar. Não podem me obrigar a isso.\n\nVou tirar meu primo do sanatório de Canton, e juntos iremos a Innsmouth."

const DESCENT_LINES: Array = [
	"Nadaremos até aquele recife que medita no mar…",
	"…mergulharemos por abismos negros até Y'ha-nthlei, ciclópica e de muitas colunas…",
	"…e naquele covil dos Profundos habitaremos, entre maravilha e glória, para sempre.",
]

const DOCS: Dictionary = {
	"doc_peabody_notes": {
		"title": "Notas genealógicas de Arkham",
		"body": "[i]Copiadas às pressas na Sociedade Histórica, com ajuda do curador, E. Lapham Peabody.[/i]\n\n• Eliza Orne, nascida em Arkham em 1867; casou-se aos 17 anos com James Williamson, de Ohio. [b]Minha avó.[/b]\n• Seu pai: Benjamin Orne, de Arkham. Casamento logo após a Guerra Civil.\n• Sua mãe: \"uma Marsh órfã de New Hampshire\", prima dos Marsh do condado de Essex; educada na França; uma governanta francesa como tutora. Morreu ao dar à luz Eliza, sua única filha.\n• Pais registrados da noiva: Enoch e Lydia (Meserve) Marsh — nunca localizados.\n• Um tio meu esteve aqui anos atrás, com a mesma busca.\n\n[i]Referências de livros sobre a família Orne, bem documentada.[/i]",
	},
	"doc_raid_clippings": {
		"title": "Recortes de fevereiro de 1928",
		"body": "[i]Recortes guardados numa gaveta.[/i]\n\nBATIDAS EM INNSMOUTH — Agentes federais realizam uma vasta série de prisões no antigo porto. Casas vazias e carcomidas ao longo da orla abandonada são queimadas e dinamitadas \"com as devidas precauções\". Fala-se em guerra ao contrabando de bebida.\n\nOS PRESOS — Nenhum julgamento, nenhuma acusação definida. Fala-se vagamente em doença e em campos de concentração; depois, em dispersão por prisões navais e militares. Nada se confirma.\n\nPROTESTOS — Entidades de defesa das liberdades civis reclamam; seus representantes são levados a visitar certos campos e prisões, e voltam surpreendentemente calados.\n\n[i]Num tabloide que ninguém leva a sério:[/i] um submarino de grande profundidade teria disparado torpedos para baixo, no abismo marinho logo além de Devil Reef.\n\n[i]Innsmouth ficou quase despovoada.[/i]",
	},
	"doc_federal_letter": {
		"title": "Carta oficial",
		"body": "[i]Papel timbrado do governo.[/i]\n\nPrezado senhor,\n\nAgradecemos sua cooperação contínua no assunto que nos relatou em julho passado. Solicitamos que mantenha a mais estrita reserva e que se coloque à disposição para novas entrevistas, que serão marcadas pelos nossos agentes.\n\n[i]Sem assinatura legível.[/i]",
	},
	"doc_orne_letters": {
		"title": "Cartas do lado Orne",
		"body": "[i]Maço de cartas dos arquivos do tio Walter.[/i]\n\nCartas de minha avó Eliza a parentes de Arkham, de antes do casamento com James Williamson. Menções à governanta francesa, \"Mademoiselle\", que nunca falava da família da patroa morta.\n\nUma carta de Walter, de anos depois, comunica o estado do filho, Lawrence, levado para o sanatório de Canton: \"o estado mental e físico dele é muito ruim\".\n\n[i]Num envelope à parte:[/i] recortes sobre a morte de Douglas, o filho mais velho de Eliza, que se matou com um tiro depois de uma viagem à Nova Inglaterra. Pouco depois, minha avó desapareceu — \"vagou para longe, de desgosto\", disseram. Eu tinha oito anos.",
	},
	"doc_photo_eliza": {
		"title": "Fotografia de Eliza Orne Williamson",
		"body": "[i]Retrato de estúdio.[/i]\n\nMinha avó, nascida em Arkham. Quando eu era criança, ela me parecia estranha, quase aterrorizante. Olhos fixos, que não piscam.",
	},
	"doc_photo_douglas": {
		"title": "Fotografia do tio Douglas",
		"body": "[i]Retrato de um homem jovem.[/i]\n\nMeu tio Douglas, o filho mais velho. Parecia-se com ela; eu nunca gostei dele. O mesmo olhar fixo, sem piscar.",
	},
	"doc_miniature": {
		"title": "Miniatura",
		"body": "[i]Pequeno retrato pintado, de uma moça de rosto estreito, em vestido de corte francês. No verso, só a palavra \"Arkham\".[/i]\n\nNinguém na família sabe dizer quem é. Os olhos são grandes demais para o rosto.",
	},
	"doc_governess_note": {
		"title": "Nota guardada com as joias",
		"body": "[i]Papel amarelado dentro da caixa, letra estrangeira.[/i]\n\n\"Ces bijoux ne doivent pas être portés en Nouvelle-Angleterre. En Europe, il n'y a aucun danger.\"\n\n[i]Walter traduz: não devem ser usadas na Nova Inglaterra; na Europa, não há perigo.[/i]",
	},
	"doc_dream_notes": {
		"title": "Notas dos sonhos",
		"body": "[i]Escritas de manhã, com a mão trêmula.[/i]\n\nGrandes espaços de água. Pórticos titânicos submersos, labirintos de muralhas ciclópicas cobertas de algas, peixes grotescos como companhia. Depois, as outras formas. No sonho eu não sentia horror: era um deles. Usava seus adornos, seguia seus caminhos aquáticos, rezava em seus templos do fundo do mar.\n\nHá muito mais do que consigo lembrar.",
	},
	"doc_canton_plan": {
		"title": "Últimas páginas",
		"body": FINAL_PAGES,
	},
}

const CHART_SLOTS: Array = [
	["slot_eliza", "Mãe de sua mãe — sua avó", "c_eliza"],
	["slot_douglas", "Filho mais velho da avó", "c_douglas"],
	["slot_walter", "Outro filho da avó", "c_walter"],
	["slot_benjamin", "Pai da avó — seu bisavô", "c_benjamin"],
	["slot_bride", "Mãe da avó — sua bisavó", "c_bride"],
	["slot_parents", "Pais registrados da bisavó", "c_parents"],
	["slot_question", "? (opcional)", "c_zadok"],
]

const CHART_CARDS: Dictionary = {
	"c_eliza": ["Eliza Orne, nascida em Arkham em 1867; casou-se aos 17 com James Williamson", "doc_photo_eliza"],
	"c_douglas": ["Douglas, que se matou depois de uma viagem à Nova Inglaterra", "doc_photo_douglas"],
	"c_walter": ["Walter Williamson; o filho dele, Lawrence, está em Canton", "doc_orne_letters"],
	"c_benjamin": ["Benjamin Orne, de Arkham; casou-se logo após a Guerra Civil", "doc_peabody_notes"],
	"c_bride": ["Uma \"Marsh de New Hampshire\", educada na França; morreu no parto em 1867", "doc_peabody_notes"],
	"c_parents": ["Enoch e Lydia (Meserve) Marsh — ninguém os localiza", "doc_peabody_notes"],
	"c_zadok": ["Zadok: uma filha de Obed, educada na Europa, casada com um homem de Arkham \"por um truque\"", "doc_zadok_record"],
	"c_tiara": ["A tiara de Newburyport, penhorada em 1873", "doc_zadok_record"],
}

const END_TITLE := "FIM"
const END_BODY := "Segundo \"The Shadow over Innsmouth\", de H. P. Lovecraft (1936).\n\nA descida a Y'ha-nthlei é uma cena simbólica, em tempo futuro: o conto termina num plano, não num ato.\n\nObrigado por jogar."
