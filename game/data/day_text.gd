class_name DayText
extends RefCounted
## Textos de ch00_frame a ch04_zadok (docs/04 §2–6). Definição imutável; PT-BR.
## Redação [O] de conteúdo [C] dos capítulos I–III do conto, salvo marcação contrária.
## Guia de estilo (docs/04 §1): sem termos depreciativos do original; "eles"/"as coisas do mar".

const CARDS: Dictionary = {
	"frame": "Toledo, Ohio — inverno de 1930–31",
	"station": "I — A Viagem\n\nNewburyport, 14 de julho de 1927, fim de tarde",
	"library": "Biblioteca Pública de Newburyport",
	"society": "Sociedade Histórica de Newburyport, à noite",
	"morning": "Newburyport — 15 de julho, 9h50",
	"bus": "II — A Cidade Esquecida",
	"square": "Innsmouth — 15 de julho, 11h",
	"secrets": "III — Os Segredos de Innsmouth",
	"zadok": "IV — O Testemunho de Zadok Allen\n\n15 de julho, 16h",
	"sunset": "19h15",
}

const OBJECTIVES: Dictionary = {
	"frame": "Escrever a primeira página.",
	"station": "Comprar a passagem mais barata para Arkham.",
	"town_eve": "Descobrir algo sobre Innsmouth antes de dormir.",
	"library": "Procurar Innsmouth nas histórias do condado.",
	"society": "Ver a tiara na Sociedade Histórica.",
	"morning": "Esperar o ônibus diante da Hammond's e embarcar.",
	"bus": "Observar o caminho.",
	"square": "Deixar a valise no Gilman House e procurar alguém que não seja daqui.",
	"grocery": "Conversar com o rapaz da mercearia.",
	"tour": "Percorrer a cidade com o mapa (refinaria, orla sul, norte do rio, ruas antigas).",
	"zadok_seen": "Arranjar algo que solte a língua do velho Zadok.",
	"lure": "Mostrar a garrafa a Zadok e levá-lo à orla sul deserta.",
	"walk": "Seguir pela Waite e pela Main até a Water Street, ao sul.",
	"wharf": "Ouvir Zadok Allen.",
	"after": "Voltar à praça. O ônibus de Arkham sai às oito.",
}

const HINTS: Dictionary = {
	"frame": ["O manuscrito está sobre a escrivaninha.", "Escreva a primeira página.", "Interaja com o manuscrito."],
	"station": ["O bilheteiro está no guichê.", "Pergunte pelo trem — e pela alternativa.", "Fale com o bilheteiro; escolha o ônibus."],
	"town_eve": ["Ninguém aqui quer falar de Innsmouth.", "A biblioteca ainda está aberta.", "Vá até a porta da biblioteca, do outro lado da rua."],
	"library": ["As histórias do condado estão nas estantes.", "Leia as histórias e depois fale com a bibliotecária.", "Leia o livro sobre a mesa; depois peça ajuda à bibliotecária."],
	"society": ["A Srta. Tilton abriu a Sociedade.", "A peça está na vitrine iluminada.", "Examine a tiara e depois fale com a Srta. Tilton."],
	"morning": ["O ônibus para diante da drogaria.", "Espere que o motorista volte da Hammond's.", "Entre no ônibus e pague a passagem."],
	"square": ["O Gilman House fica no lado oeste da praça.", "Deixe a valise com o funcionário; depois procure a mercearia da rede.", "Saguão do Gilman; depois a mercearia First National, ao sul da praça."],
	"grocery": ["O rapaz quer conversar.", "Pergunte sobre as ruas, os moradores, os Marsh e Zadok.", "Esgote os assuntos com o rapaz para receber o mapa."],
	"tour": ["O mapa está no Diário.", "Quatro regiões: refinaria (ponte da Federal, a leste), orla sul (Waite, Main), norte do rio (Main, Water), ruas antigas (Washington ao norte).", "Visite três das quatro regiões; depois volte para o sul pela ponte precária da Washington."],
	"zadok_seen": ["Zadok bebe.", "Há bebida nos fundos de uma loja na Eliot Street.", "Vá à loja de variedades na Eliot, ao sul da praça, e compre a garrafa."],
	"lure": ["Zadok anda perto do Gilman.", "Mostre a garrafa a ele.", "Interaja com Zadok e siga pela Waite, a leste."],
	"walk": ["A orla sul está deserta.", "Waite até a Main, depois Water Street para o sul.", "Siga até o cais de terra no fim da Water Street, ao sul."],
	"wharf": ["Quando ele travar, ofereça a garrafa.", "Não ofereça enquanto ele fala.", "Interaja com Zadok quando ele ficar em silêncio."],
	"after": ["A praça fica a oeste.", "Siga a orientação do Diário.", "Volte à praça."],
}

const NOTES: Dictionary = {
	"frame": "Comecei a escrever. Escrever me ajuda a confiar nos meus próprios sentidos.",
	"agent": "O bilheteiro: um ônibus velho passa por Innsmouth; sai da Hammond's às 10h e às 19h. O povo daqui detesta aquela gente — medo, mais que tudo, segundo ele.",
	"library": "Innsmouth: fundada em 1643; estaleiros; prosperidade; depois só a Marsh Refining. Uma epidemia e tumultos em 1846, mal contados. Joias estranhas no museu da Miskatonic e na Sociedade Histórica.",
	"tiara": "A tiara: nenhuma tradição conhecida. Relevos de criaturas meio peixe, meio rã. Por que me pareceram lembradas?",
	"tilton": "Srta. Tilton: penhorada em 1873 por um bêbado de Innsmouth; os Marsh insistem em comprá-la; a Ordem Esotérica de Dagon engoliu as igrejas.",
	"sargent": "Joe Sargent devolveu o troco sem dizer palavra. Não sei de onde vem a aversão que ele me causa.",
	"priest": "Na porta do porão da igreja, uma figura com uma tiara igual à de Newburyport. Era só o pastor. Por que senti aquele frio?",
	"grocery": "O rapaz da mercearia, de Arkham: evitar a refinaria, as igrejas em uso e a Ordem de Dagon. Festas em 30 de abril e 31 de outubro. Os velhos quase nunca aparecem.",
	"zadok_info": "Zadok Allen, 96 anos, mora no asilo, anda pelo quartel dos bombeiros. Fala quando bebe. Não é seguro ser visto com ele.",
	"refinery": "A refinaria Marsh, estranhamente silenciosa para uma indústria.",
	"waterfront": "A orla sul: deserção total. O terror de uma casa vazia cresce em progressão geométrica quando as casas formam uma cidade.",
	"north": "Ao norte do rio, os sons eram mais fortes atrás das fachadas tapadas do que nas casas habitadas.",
	"patrician": "Os casarões da Washington: sótãos fechados, nenhum gato, nenhum cachorro. A mansão de Old Man Marsh, a mais suntuosa.",
	"zadok_seen": "Zadok Allen, no banco do quartel. Os mitos mais loucos costumam ser alegorias de uma verdade — e ele viu tudo.",
	"jrn_islands": "Das ilhas, Zadok só repete o que Obed e Matt Eliot contavam. Ele mesmo nunca esteve lá.",
	"jrn_obed_daughter": "Segundo Zadok, uma filha de Obed, educada na Europa, casou-se \"por um truque\" com um homem de Arkham.",
	"jrn_obed_eyes": "Zadok disse que eu tenho \"olhos de quem lê os outros\", como os de Obed. Bobagem de bêbado.",
	"zadok_fled": "Zadok gritou, olhando o mar atrás de mim, e fugiu. Quando cheguei à Water Street, não havia sinal dele.",
}

const THOUGHTS: Dictionary = {
	"frame": "Chove na vidraça. O espelho continua coberto.",
	"cheaper": "O trem para Arkham é caro demais para o meu bolso.",
	"no_talk": "Ninguém quer falar de Innsmouth. Uma desconfiança obscura, como se houvesse algo de errado em quem se interessa demais.",
	"tiara_look": "Nenhuma tradição que eu conheça — oriental ou ocidental, antiga ou moderna. Como se o ourives fosse de outro planeta.",
	"tiara_creatures": "E essas criaturas, meio peixe, meio rã... por que me parecem lembradas?",
	"ymca": "No quarto da Y.M.C.A., quase não durmo. À arquitetura e à história junta-se agora um zelo antropológico.",
	"avoid": "Os ociosos se afastam quando o ônibus se aproxima. O bilheteiro não exagerou.",
	"sargent": "Por que ele me causa tanta aversão? Não sei dizer de onde vem.",
	"crest": "Do alto, Innsmouth: muito extensa, densamente construída — e quase sem sinal de vida.",
	"reef": "Ao longe, uma linha negra mal acima da água. Devil Reef. Além da repulsa, algo como um aceno.",
	"green": "Igrejas dos dois lados, os restos de um gramado circular e um salão de colunas: \"Esoteric Order of Dagon\".",
	"bell": "Um sino rachado bate onze horas, do outro lado da rua.",
	"priest": "Era só o pastor, com vestes do culto. Por que senti aquele frio?",
	"falls": "O desfiladeiro, as quedas, as fábricas no barranco. O ruído é ensurdecedor.",
	"lobby": "Um funcionário idoso, sem aquela aparência. Melhor não perguntar nada aqui.",
	"map": "Um mapa tosco, mas generoso e cuidadoso. Vai ser de grande ajuda.",
	"refinery": "A refinaria Marsh fica no barranco, junto à Old Square, o primeiro centro da cidade. Silenciosa demais.",
	"waterfront": "Nenhuma criatura viva. Só a maré e o rugido das quedas. Olho para trás a cada esquina.",
	"north": "Rangidos, correrias, ruídos roucos — mais fortes justamente atrás das fachadas tapadas.",
	"woman": "Uma mulher puxa a criança para dentro e fecha a veneziana. Não sei se de medo de mim ou por mim.",
	"patrician": "Nenhum gato, nenhum cachorro. E os sótãos fechados, mesmo nos casarões bem cuidados.",
	"order_watch": "Três homens à porta do salão param de conversar e me observam até eu me afastar.",
	"bell_three": "O sino rachado bate três horas — a mesma igreja do porão.",
	"bridge": "Uma placa adverte: ponte insegura. Arrisco.",
	"zadok": "É Zadok Allen. Os mitos mais loucos costumam ser alegorias de uma verdade — e ele viu tudo.",
	"firemen": "Os bombeiros me encaram e o velho se cala. Melhor me preparar antes.",
	"whiskey": "Uma garrafa, fácil de achar, nada barata.",
	"follow": "Ele me segue, arrastando os pés, de olho na garrafa.",
	"hey": "\"Ei, moço!\" — um chiado atrás de mim.",
	"gone": "Nenhum sinal de Zadok Allen. A cidade inteira parece prender a respiração.",
	"after": "A hora ficou perigosamente tarde. O ônibus de Arkham sai da praça às oito.",
}

# ---------------------------------------------------------------- diálogos de ch01

const AGENT_INTRO := "Para Arkham? O trem é o melhor caminho, mas não é barato, não."
const AGENT_TOPICS: Dictionary = {
	"bus": ["Não há nada mais barato?", "Tem aquele ônibus velho, se o senhor não for exigente. Passa por Innsmouth — e o povo daqui não gosta dele. Sai da praça, na frente da Hammond's, às dez e às sete."],
	"town": ["O que há de errado com Innsmouth?", "Já foi quase uma cidade grande, antes da guerra de 1812. Hoje tem mais casa vazia que gente. Contam histórias de um tal capitão Marsh e de um recife lá fora... Eu sou de Vermont; essas coisas não me pegam. O pessoal daqui detesta aquela gente. Medo, mais que tudo, eu acho."],
	"hotel": ["Há onde ficar por lá?", "O Gilman House. Não recomendo. Um inspetor de fábricas, Casey, dormiu lá uma vez: ouviu vozes nos quartos vazios a noite inteira. Não tirou a roupa e foi embora cedo."],
}
const LIBRARIAN := "Innsmouth? Um caso exagerado de decadência, só isso. Mas se faz questão de ver a peça, a Srta. Tilton mora aqui perto e talvez abra a Sociedade. Não é tão tarde. Vou escrever um bilhete."
const TILTON: Array = [
	["Srta. Anna Tilton", "Foi penhorada por uma ninharia, em 1873, numa loja da State Street, por um homem de Innsmouth que andava bêbado — morreu numa briga logo depois. Compramos direto do penhorista.", ["E de onde ela vem?"]],
	["Srta. Anna Tilton", "A etiqueta diz \"provável procedência das Índias Orientais ou da Indochina\", mas é palpite. Eu acho que é parte de algum tesouro pirata achado pelo velho capitão Obed Marsh. Os Marsh oferecem uma fortuna por ela até hoje. Nunca vendemos.", ["E o que há de errado com a cidade?"]],
	["Srta. Anna Tilton", "Uma cidade em decadência desde a epidemia, cada vez mais fechada em si. E os boatos de culto têm fundamento: a Ordem Esotérica de Dagon, trazida do Oriente quando a pesca minguou. A pesca voltou, e o culto ficou — engoliu todas as igrejas e tomou a velha Loja Maçônica da New Church Green.", ["Obrigado, senhorita."]],
]
const YMCA := "O recepcionista da Y.M.C.A. só desaconselha: um lugar triste, decadente. Ninguém vai lá a passeio."
const SARGENT_FARE := "[O motorista olha você por um segundo, sem piscar, e devolve quarenta centavos sem dizer palavra.]"

# ---------------------------------------------------------------- diálogos de ch02–ch03

const DAY_CLERK := "Deixe a valise aqui. O ônibus de Arkham sai às oito, da praça."
const GROCERY_INTRO := "Um forasteiro! O senhor não imagina o alívio. Sou de Arkham — a rede me transferiu para cá. Pergunte o que quiser."
const GROCERY_TOPICS: Dictionary = {
	"streets": ["Como me oriento na cidade?", "Não há biblioteca nem nada. A rua por onde o senhor veio é a Federal. A oeste, as ruas boas antigas — Broad, Washington, Lafayette, Adams. A leste, os cortiços da orla, e na Main as igrejas georgianas, todas abandonadas."],
	"avoid": ["Há lugares a evitar?", "Não fique rondando a refinaria Marsh, nem as igrejas em uso, nem o salão da Ordem de Dagon, na New Church Green. E cuidado ao norte do rio: o povo é emburrado. Já sumiu forasteiro por aqui."],
	"churches": ["E as igrejas?", "Esquisitas. Todas renegadas pelas denominações de fora. Falam em transformações maravilhosas, numa imortalidade do corpo — de algum tipo — aqui mesmo. Cantam à noite, sobretudo nas festas: 30 de abril e 31 de outubro. Meu pastor em Arkham me pediu para não entrar em nenhuma."],
	"people": ["E os moradores?", "Arredios como bicho de toca. Aqueles olhos que nunca se fecham... Nadam muito — corrida até o recife é comum. A gente quase nunca vê os velhos; os mais velhos que aparecem são os mais... diferentes. Fico pensando se não é uma doença que piora com a idade."],
	"marsh": ["E os Marsh?", "O velho Marsh nunca é visto; vai à refinaria num carro fechado, de cortinas. Os filhos sumiram do escritório. Uma das filhas usa joias estranhas, do mesmo tipo daquela tiara famosa. Marsh, Waite, Gilman, Eliot — as quatro famílias de bem moram nos casarões da Washington."],
	"zadok": ["Alguém aqui conversa?", "Só o velho Zadok Allen, noventa e seis anos, do asilo. Vive pelo quartel dos bombeiros. Sóbrio, não fala; com uísque, conta as histórias mais loucas. Ninguém acredita nele — mas o povo não gosta que ele beba e converse com estranhos. Não é seguro ser visto perguntando. Bebida? Tem bastante nos fundos de uma loja de variedades, na Eliot."],
}
const GROCERY_MAP := "As placas das ruas caíram quase todas. Espere — vou desenhar para o senhor."
const VARIETY := "Um quarto de galão. Os compradores de ouro também gostam. Leve embrulhado."
const ORDER_NOTICE := "Aviso desbotado na porta"

# ---------------------------------------------------------------- Zadok (docs/04 §6)

## Cada movimento: falas (legendas de Zadok) e se precisa da garrafa para começar.
const MOVEMENTS: Array = [
	{"bottle": false, "lines": [
		"Jornal? Leio todos, moço. Esse tal de Coolidge... Hein? O passado? Não é coisa pra se falar com estranho.",
		"O tempo anda bom. O peixe anda bom. Sempre anda bom, aqui.",
		"Hein? Ah. Dá cá mais um gole, que a goela seca.",
	]},
	{"bottle": true, "lines": [
		"Foi ali que tudo começou — naquele lugar maldito onde a água funda começa. Porta do inferno. Desce até um fundo que nenhum prumo alcança.",
		"Foi o Cap'n Obed que fez a coisa. Tempo ruim, aquele: comércio caindo, os moinhos perdendo freguês, os melhores homens mortos na guerra de 1812.",
		"O Obed tinha três navios: o Columby, o Hetty e o Sumatry Queen. Dizia que a gente era um bando de ovelha rezando pra um céu que não ajudava.",
		"O Matt Eliot, o imediato, contava de uma ilha a leste do Taiti, com ruínas de pedra mais velhas que tudo, e uma ilhota vulcânica com entalhes de monstros.",
		"Eu repito o que o Obed e o Matt contavam, hein? Nunca estive lá.",
	]},
	{"bottle": true, "lines": [
		"O povo da ilha tinha peixe à vontade e enfeites de um ouro esquisito. O Obed arrancou a história do chefe deles, um tal Walakea.",
		"Davam gente moça às coisas do mar, duas vezes por ano — véspera de maio e Dia das Bruxas. E as coisas davam peixe, e ouro de vez em quando.",
		"Depois as coisas quiseram se misturar com o povo. Os filhos nasciam parecendo gente, e com o tempo iam mudando, até voltar pra água.",
		"E essa é a parte que importa, moço: os que viram bicho do mar e vão pra água nunca morrem.",
	]},
	{"bottle": true, "lines": [
		"O Walakea deu ao Obed uma coisa de chumbo, que chamava as coisas de qualquer ninho, jogada na água com as rezas certas.",
		"O ouro saía barato. O Obed montou a refinaria no velho moinho de pisoar do Waite — não dava pra vender as peças inteiras, o povo ia perguntar.",
		"Lá por 1838 os vizinhos da ilha acabaram com todo mundo. Deviam ter os sinais dos Antigos, que eram a única coisa que as coisas do mar temiam.",
		"O Obed ficou arruinado. Começou a dizer na cidade que sabia de deuses que davam o que a gente precisava de verdade...",
		"[Zadok esvazia a garrafa, lambe o gargalo e a guarda no bolso.] Dagon e Astarote... Belial e Belzebu... Mene, mene, tequel...",
	]},
	{"bottle": false, "lines": [
		"Não acredita, hein? Então me diga por que o Obed e uns vinte remavam pro recife de noite, cantando alto, com o vento a favor.",
		"Eu era menino. Subi na cúpula de casa com o óculo do pai e vi o recife cheio de formas que mergulhavam do outro lado quando a lua subia.",
		"No dia seguinte faltava gente moça em casa. O Hiram Gilman. O Nick Pierce. A Luelly Waite. O Adoniram Southwick. O Henry Garrison. Alguém viu de novo?",
		"O peixe voltou, o ouro voltou. O Obed fez passar o ramal da ferrovia. E fundaram a Ordem de Dagon, compraram a Loja Maçônica. O Matt Eliot sumiu bem nessa época.",
	]},
	{"bottle": false, "lines": [
		"Em 46 a cidade resolveu olhar. Eu contei ao selectman Mowry o que via da cúpula. Seguiram o bando do Obed até o recife; teve tiro entre os botes.",
		"No dia seguinte, o Obed e mais trinta e dois na cadeia. Duas semanas sem jogar nada no mar...",
		"Aquela noite... eu vi da cúpula. Aos montes. Subindo o porto, entrando no Manuxet. Gritaria na Old Square, na praça, na New Church Green.",
		"Eles sacudiram a nossa porta, mas o pai não abriu... depois saiu pela janela da cozinha com o mosquete. Nunca mais soube dele.",
		"De fora, chamaram de peste. Quem sobrou jurou com o Obed — o primeiro juramento de Dagon, depois o segundo. Eu fiz os dois. O terceiro, não. Preferia morrer.",
	]},
	{"bottle": false, "lines": [
		"E vosmecê... tem uns olhos de quem lê os outros, igual o Obed tinha.",
		"O Obed tomou outra mulher em 46, que ninguém nunca viu. Três filhos: dois sumiram pequenos; uma menina como qualquer outra, educada na Europa. O Obed casou ela com um homem de Arkham, por um truque.",
		"O Barnabas Marsh, que manda na refinaria agora, já quase mudou. Não fecha mais o olho. Vai pra água logo.",
		"O horror de verdade não é o que eles fizeram — é o que vão fazer. As casas ao norte do rio, entre a Water e a Main, estão cheias deles e do que trouxeram lá de baixo...",
		"Já ouviu falar de um shoggoth? Hein? Não fique me olhando com esses olhos!",
	]},
]

const TOPICS: Dictionary = {
	"topic_tiara": ["As joias", "Os marinheiros vendiam escondido. E o Obed deixava as mulheres dele usarem as peças que pareciam mais com gente."],
	"topic_reef": ["O recife", "Corrida de natação até lá é coisa comum. Do outro lado o fundo desce feito um penhasco."],
	"topic_refinery_gold": ["O ouro da refinaria", "Não dava pra vender inteiro. Derretiam no moinho do Waite e mandavam em barra."],
	"topic_churches": ["As igrejas", "Correram com o pastor congregacional, o metodista desistiu, e o batista sumiu. Os padres novos eram ex-marinheiros, de manto e ouro na cabeça."],
	"topic_marsh_house": ["A casa dos Marsh", "A mãe do Barnabas nunca foi vista ao ar livre. A mulher dele é de Ipswich — quase lincharam o Barnabas quando ele foi cortejar."],
	"topic_1846": ["A epidemia de 1846", "Peste! Foi o nome que deram de fora."],
	"topic_look": ["A aparência do povo", "Vão pra água quando estão prontos. Às vezes descem antes, de experiência, e voltam."],
}
const STALL_LINES: Array = ["Zadok se cala e olha por cima do ombro", "Zadok resmunga, olhando o recife", "Zadok encara o mar, em silêncio"]
const DOZE := "Zadok bebeu depressa demais e cochila, resmungando"
const TOO_SOON := "Calma, moço. Deixa o velho falar."
const SHRIEK_1 := "EH—AHHH! E'YAAHHH!"
const SHRIEK_2 := "Sai daqui! Eles viram a gente — corre, sai da cidade, não espera nada — eles sabem agora!"

# ---------------------------------------------------------------- documentos

const DOCS: Dictionary = {
	"doc_manuscript": {
		"title": "Primeira página do manuscrito",
		"body": "No inverno de 1927 para 1928, agentes do governo federal fizeram uma investigação estranha e secreta no antigo porto de Innsmouth, em Massachusetts. Os jornais falaram de uma guerra ao contrabando de bebida.\n\nFui eu quem fugiu daquela cidade na madrugada de 16 de julho de 1927, e foram os meus apelos que provocaram tudo.\n\nEscrever me ajuda a confiar nos meus próprios sentidos — a me convencer de que não fui apenas o primeiro a sucumbir a um pesadelo contagioso. Ajuda também a decidir um certo passo que tenho diante de mim.",
	},
	"doc_bus_timetable": {
		"title": "Anotação do bilheteiro",
		"body": "[i]Num pedaço de papel, a lápis.[/i]\n\nÔnibus Arkham–Innsmouth–Newburyport\nSai da praça, em frente à Hammond's Drug Store\n10h e 19h (\"se não mudaram\")\nDe Innsmouth para Arkham: 20h\n\nMotorista: Joe Sargent.",
	},
	"doc_essex_history": {
		"title": "Histórias do condado de Essex (trechos)",
		"body": "[i]Volumes da biblioteca.[/i]\n\nINNSMOUTH — Fundada em 1643. Famosa pelos estaleiros antes da Revolução; grande prosperidade marítima no início do século XIX; depois, pequeno centro fabril movido pelo rio Manuxet.\n\nA epidemia e os tumultos de 1846 são tratados muito por alto, como se fossem um descrédito para o condado.\n\nApós a Guerra Civil, toda a vida industrial se resume à Marsh Refining Company; o comércio de lingotes de ouro é a única atividade importante, além da pesca eterna. Poucos estrangeiros se fixaram ali; alguns que tentaram foram \"dispersos\" de forma peculiarmente drástica.",
	},
	"doc_jewellery_note": {
		"title": "Nota sobre as joias de Innsmouth",
		"body": "[i]Referência de passagem num dos volumes.[/i]\n\nPeças de uma joalheria estranha, vagamente associada a Innsmouth, impressionaram toda a região. Há exemplares no museu da Universidade Miskatonic, em Arkham, e na sala de exposição da Sociedade Histórica de Newburyport — entre eles, uma peça grande, de proporções singulares, evidentemente uma tiara.",
	},
	"doc_intro_note": {
		"title": "Bilhete da bibliotecária",
		"body": "[i]Cartão com letra caprichada.[/i]\n\nCara Srta. Tilton,\n\nO portador é um jovem estudante interessado em antiguidades, desejoso de ver a peça de Innsmouth da Sociedade. Se não for incômodo a esta hora...\n\nCom estima.",
	},
	"doc_tiara_label": {
		"title": "Etiqueta da vitrine",
		"body": "TIARA\nOuro e liga não identificada.\nProvável procedência das Índias Orientais ou da Indochina (atribuição provisória).\nAdquirida de penhorista, State Street, 1873.",
	},
	"doc_marsh_offers": {
		"title": "Carta da família Marsh",
		"body": "[i]Uma de várias, num arquivo da Sociedade.[/i]\n\nPrezados senhores,\n\nRenovamos nossa oferta pela tiara em seu poder, cujo valor sentimental para a família é grande. Estamos dispostos a elevar bastante a quantia proposta.\n\nMarsh Refining Company, Innsmouth.",
	},
	"doc_gilman_register": {
		"title": "Livro de registro do Gilman House",
		"body": "[i]Páginas amarelas, poucas assinaturas por ano.[/i]\n\nNomes de caixeiros-viajantes, compradores de ouro, um fiscal do estado... Duas temporadas atrás, uma assinatura apressada: \"Casey — inspetor de fábricas\". Partida: \"cedo\".",
	},
	"doc_bridge_warning": {
		"title": "Placa na ponte",
		"body": "PONTE INSEGURA\nPASSE POR SUA CONTA E RISCO",
	},
	"doc_order_notice": {
		"title": "Aviso na porta da Ordem",
		"body": "[i]Papel desbotado, letra antiga.[/i]\n\nESOTERIC ORDER OF DAGON\nAssembleias solenes: 30 de abril — 31 de outubro.\nSomente para os iniciados.",
	},
	"doc_church_tract": {
		"title": "Folheto de igreja",
		"body": "[i]Achado no chão, perto da Main.[/i]\n\n\"...e os fiéis não conhecerão a morte, mas uma transformação maravilhosa, e viverão para sempre junto ao Pai e à Mãe de onde todos viemos...\"",
	},
	"doc_sketch_map": {
		"title": "Mapa desenhado pelo rapaz da mercearia",
		"body": "[i]Esboço a lápis, rude mas cuidadoso. Muitas placas de rua caíram.[/i]\n\n• [b]Town Square[/b], na margem sul do Manuxet. O Gilman House no lado oeste; a mercearia ao sul; a [b]Eliot[/b] sai da praça para o sul (loja de variedades).\n• [b]Ponte da Federal[/b] para o norte: a New Church Green e o salão da Ordem — [i]evitar[/i].\n• A leste da ponte, no barranco, a [b]refinaria Marsh[/b] e a Old Square.\n• [b]Orla sul[/b]: a [b]Waite[/b] leva à [b]Main[/b]; depois [b]Fish[/b] e [b]Water[/b], junto aos cais.\n• [b]Ao norte do rio[/b]: Main e Water (ponte da Water precária; a da Fish caiu). Igrejas velhas na Main com a Church.\n• [b]Ruas antigas[/b] a oeste: Washington, Lafayette — casarões; a mansão Marsh. A [b]ponte da Washington[/b] volta para o sul; a [b]Paine[/b] leva à praça (quartel dos bombeiros).\n• Ao sul pela Washington: Bates, a praça da Eliot com a South — [i]espaço aberto[/i]. A oeste, a Bank Street e a velha estação; os trilhos abandonados seguem para Rowley.\n\n[i]Anotação do rapaz:[/i] a melhor saída da cidade é para o sul.",
	},
}
