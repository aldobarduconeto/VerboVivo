import '../models/reading_plan_model.dart';

class ReadingPlanService {
  const ReadingPlanService();

  static const List<ReadingPlan> plans = [
    // 1. Sabedoria em 30 Dias
    ReadingPlan(
      id: 'plan-sabedoria-30',
      title: 'Sabedoria Diária',
      subtitle: 'Salmos e Provérbios em 30 Dias',
      description:
          'Um mergulho poético e prático na sabedoria milenar de Israel para iluminar suas decisões e nutrir seu espírito.',
      category: 'Sabedoria & Oração',
      iconName: 'book',
      days: [
        ReadingPlanDay(
          dayNumber: 1,
          title: 'O Caminho do Justo e o Temor do Senhor',
          passages: ['Salmos 1', 'Provérbios 1'],
          focusThought: 'O temor do Senhor é o princípio do conhecimento.',
        ),
        ReadingPlanDay(
          dayNumber: 2,
          title: 'Proteção e Busca pelo Entendimento',
          passages: ['Salmos 2', 'Provérbios 2'],
          focusThought: 'Se clamares por entendimento, acharás o conhecimento de Deus.',
        ),
        ReadingPlanDay(
          dayNumber: 3,
          title: 'Confiança Incondicional no Pai',
          passages: ['Salmos 3', 'Provérbios 3'],
          focusThought: 'Confia no Senhor de todo o teu coração e não te estribes no teu próprio entendimento.',
        ),
        ReadingPlanDay(
          dayNumber: 4,
          title: 'Guarda o Teu Coração',
          passages: ['Salmos 4', 'Provérbios 4'],
          focusThought: 'Sobre tudo o que se deve guardar, guarda o teu coração, porque dele procedem as fontes da vida.',
        ),
        ReadingPlanDay(
          dayNumber: 5,
          title: 'Oração Matutina e Pureza de Caminhos',
          passages: ['Salmos 5', 'Provérbios 5'],
          focusThought: 'De manhã ouvirás a minha voz, ó Senhor; de manhã te apresentarei a minha oração.',
        ),
        ReadingPlanDay(
          dayNumber: 6,
          title: 'Clamor por Misericórdia e Diligência',
          passages: ['Salmos 6', 'Provérbios 6'],
          focusThought: 'Vai ter com a formiga, ó preguiçoso; olha para os seus caminhos e sê sábio.',
        ),
        ReadingPlanDay(
          dayNumber: 7,
          title: 'Refúgio Seguro e a Palavra no Olhar',
          passages: ['Salmos 7', 'Provérbios 7'],
          focusThought: 'Guarda os meus mandamentos e vive; guarda a minha lei como a menina dos teus olhos.',
        ),
        ReadingPlanDay(
          dayNumber: 8,
          title: 'A Excelência de Deus e o Chamado da Sabedoria',
          passages: ['Salmos 8', 'Provérbios 8'],
          focusThought: 'Quão magnífico em toda a terra é o teu nome, ó Senhor!',
        ),
        ReadingPlanDay(
          dayNumber: 9,
          title: 'Louvor com Todo o Coração e o Banquete da Sabedoria',
          passages: ['Salmos 9', 'Provérbios 9'],
          focusThought: 'O temor do Senhor é o princípio da sabedoria.',
        ),
        ReadingPlanDay(
          dayNumber: 10,
          title: 'Refúgio na Opressão e Palavras de Bênção',
          passages: ['Salmos 10', 'Provérbios 10'],
          focusThought: 'A boca do justo é manancial de vida.',
        ),
        ReadingPlanDay(
          dayNumber: 11,
          title: 'O Senhor no Seu Santo Templo',
          passages: ['Salmos 11', 'Provérbios 11'],
          focusThought: 'Balança enganosa é abominação para o Senhor, mas o peso justo é o seu prazer.',
        ),
        ReadingPlanDay(
          dayNumber: 12,
          title: 'Pureza da Palavra e Sabedoria Prática',
          passages: ['Salmos 12', 'Provérbios 12'],
          focusThought: 'As palavras do Senhor são palavras puras como prata refinada.',
        ),
        ReadingPlanDay(
          dayNumber: 13,
          title: 'Esperança Paciente e Fruto da Retidão',
          passages: ['Salmos 13', 'Provérbios 13'],
          focusThought: 'Eu confio na tua benignidade; o meu coração se regozijará na tua salvação.',
        ),
        ReadingPlanDay(
          dayNumber: 14,
          title: 'Edificação do Lar e Justiça Divina',
          passages: ['Salmos 14', 'Provérbios 14'],
          focusThought: 'Toda mulher sábia edifica a sua casa.',
        ),
        ReadingPlanDay(
          dayNumber: 15,
          title: 'Habitar no Tabernáculo e a Resposta Branda',
          passages: ['Salmos 15', 'Provérbios 15'],
          focusThought: 'A resposta branda desvia o furor, mas a palavra dura suscita a ira.',
        ),
        ReadingPlanDay(
          dayNumber: 16,
          title: 'A Bela Herança e a Entrega dos Planos',
          passages: ['Salmos 16', 'Provérbios 16'],
          focusThought: 'Confia ao Senhor as tuas obras, e os teus desígnios serão estabelecidos.',
        ),
        ReadingPlanDay(
          dayNumber: 17,
          title: 'A Menina dos Olhos e a Amizade Fiel',
          passages: ['Salmos 17', 'Provérbios 17'],
          focusThought: 'Em todo o tempo ama o amigo, e na angústia nasce o irmão.',
        ),
        ReadingPlanDay(
          dayNumber: 18,
          title: 'O Deus que me Cinge de Força e Torre Forte',
          passages: ['Salmos 18', 'Provérbios 18'],
          focusThought: 'Torre forte é o nome do Senhor; para ela corre o justo e está seguro.',
        ),
        ReadingPlanDay(
          dayNumber: 19,
          title: 'Os Céus Proclamam e o Entendimento Humano',
          passages: ['Salmos 19', 'Provérbios 19'],
          focusThought: 'Os céus declaram a glória de Deus e o firmamento anuncia a obra das suas mãos.',
        ),
        ReadingPlanDay(
          dayNumber: 20,
          title: 'Socorro no Dia da Angústia e a Lâmpada do Senhor',
          passages: ['Salmos 20', 'Provérbios 20'],
          focusThought: 'Uns confiam em carros, outros em cavalos; nós, porém, nos gloriaremos no nome do Senhor.',
        ),
        ReadingPlanDay(
          dayNumber: 21,
          title: 'Força Real e Coração nas Mãos de Deus',
          passages: ['Salmos 21', 'Provérbios 21'],
          focusThought: 'Como ribeiros de águas assim é o coração do rei na mão do Senhor.',
        ),
        ReadingPlanDay(
          dayNumber: 22,
          title: 'Do Clamor ao Triunfo e o Bom Nome',
          passages: ['Salmos 22', 'Provérbios 22'],
          focusThought: 'Mais vale o bom nome do que as muitas riquezas.',
        ),
        ReadingPlanDay(
          dayNumber: 23,
          title: 'O Bom Pastor e a Busca pela Verdade',
          passages: ['Salmos 23', 'Provérbios 23'],
          focusThought: 'O Senhor é o meu pastor; nada me faltará.',
        ),
        ReadingPlanDay(
          dayNumber: 24,
          title: 'O Rei da Glória e Edificação da Casa',
          passages: ['Salmos 24', 'Provérbios 24'],
          focusThought: 'Com a sabedoria se edifica a casa, e com a inteligência ela se firma.',
        ),
        ReadingPlanDay(
          dayNumber: 25,
          title: 'Guia os Mansos e Palavra dita a seu Tempo',
          passages: ['Salmos 25', 'Provérbios 25'],
          focusThought: 'Como maçãs de ouro em salvas de prata, assim é a palavra dita a seu tempo.',
        ),
        ReadingPlanDay(
          dayNumber: 26,
          title: 'Caminho Íntegro e o Homem Diligente',
          passages: ['Salmos 26', 'Provérbios 26'],
          focusThought: 'Examina-me, Senhor, e prova-me; esquadrinha o meu coração e a minha mente.',
        ),
        ReadingPlanDay(
          dayNumber: 27,
          title: 'Luz, Salvação e o Amigo Leal',
          passages: ['Salmos 27', 'Provérbios 27'],
          focusThought: 'O Senhor é a minha luz e a minha salvação; de quem terei medo?',
        ),
        ReadingPlanDay(
          dayNumber: 28,
          title: 'Rocha Protetora e Consciência em Paz',
          passages: ['Salmos 28', 'Provérbios 28'],
          focusThought: 'O ímpio foge sem que ninguém o persiga, mas o justo é ousado como o leão.',
        ),
        ReadingPlanDay(
          dayNumber: 29,
          title: 'A Voz Poderosa de Deus e a Visão Clara',
          passages: ['Salmos 29', 'Provérbios 29'],
          focusThought: 'O Senhor dá força ao seu povo; o Senhor abençoa o seu povo com paz.',
        ),
        ReadingPlanDay(
          dayNumber: 30,
          title: 'Alegria pela Manhã e Louvor à Mulher Virtuosa',
          passages: ['Salmos 30', 'Provérbios 31'],
          focusThought: 'O choro pode durar uma noite, mas a alegria vem pela manhã.',
        ),
      ],
    ),

    // 2. A Vida e Ensinos de Jesus (21 Dias)
    ReadingPlan(
      id: 'plan-jesus-21',
      title: 'Passos do Mestre',
      subtitle: '21 Dias com Jesus nos Evangelhos',
      description:
          'Acompanhe de perto os milagres, parábolas, compaixão e a vitória transformadora de Jesus Cristo.',
      category: 'Vida de Jesus',
      iconName: 'sparkles',
      days: [
        ReadingPlanDay(
          dayNumber: 1,
          title: 'O Verbo se Fez Carne',
          passages: ['João 1'],
          focusThought: 'E o Verbo se fez carne e habitou entre nós, cheio de graça e de verdade.',
        ),
        ReadingPlanDay(
          dayNumber: 2,
          title: 'O Sermão da Montanha: Bem-Aventuranças',
          passages: ['Mateus 5'],
          focusThought: 'Vós sois o sal da terra e a luz do mundo.',
        ),
        ReadingPlanDay(
          dayNumber: 3,
          title: 'A Oração do Pai Nosso e a Ansiedade',
          passages: ['Mateus 6'],
          focusThought: 'Buscai primeiro o reino de Deus e a sua justiça, e todas estas coisas vos serão acrescentadas.',
        ),
        ReadingPlanDay(
          dayNumber: 4,
          title: 'A Casa sobre a Rocha',
          passages: ['Mateus 7'],
          focusThought: 'Todo aquele que ouve estas minhas palavras e as pratica será comparado a um homem prudente.',
        ),
        ReadingPlanDay(
          dayNumber: 5,
          title: 'Nicodemos e o Novo Nascimento',
          passages: ['João 3'],
          focusThought: 'Porque Deus amou o mundo de tal maneira que deu o seu Filho unigênito.',
        ),
        ReadingPlanDay(
          dayNumber: 6,
          title: 'A Mulher Samaritana e a Água da Vida',
          passages: ['João 4'],
          focusThought: 'Aquele que beber da água que eu lhe der nunca terá sede.',
        ),
        ReadingPlanDay(
          dayNumber: 7,
          title: 'O Paralítico de Cafarnaum',
          passages: ['Marcos 2'],
          focusThought: 'Filho, perdoados estão os teus pecados. Levanta-te, toma o teu leito e vai para tua casa.',
        ),
        ReadingPlanDay(
          dayNumber: 8,
          title: 'A Tempestade Acalmada',
          passages: ['Marcos 4'],
          focusThought: 'Cala-te, emudece! E o vento se aquietou, e houve grande bonança.',
        ),
        ReadingPlanDay(
          dayNumber: 9,
          title: 'O Pão da Vida',
          passages: ['João 6'],
          focusThought: 'Eu sou o pão da vida; quem vem a mim não terá fome.',
        ),
        ReadingPlanDay(
          dayNumber: 10,
          title: 'O Bom Samaritano',
          passages: ['Lucas 10'],
          focusThought: 'Vai e faze da mesma maneira.',
        ),
        ReadingPlanDay(
          dayNumber: 11,
          title: 'O Filho Pródigo e o Abraço do Pai',
          passages: ['Lucas 15'],
          focusThought: 'Este meu filho estava morto e reviveu; tinha-se perdido e foi achado.',
        ),
        ReadingPlanDay(
          dayNumber: 12,
          title: 'A Ressurreição de Lázaro',
          passages: ['João 11'],
          focusThought: 'Eu sou a ressurreição e a vida; quem crê em mim, ainda que esteja morto, viverá.',
        ),
        ReadingPlanDay(
          dayNumber: 13,
          title: 'Zaqueu e a Salvação no Lar',
          passages: ['Lucas 19'],
          focusThought: 'Porque o Filho do homem veio buscar e salvar o que se havia perdido.',
        ),
        ReadingPlanDay(
          dayNumber: 14,
          title: 'O Lava-Pés e o Novo Mandamento',
          passages: ['João 13'],
          focusThought: 'Novo mandamento vos dou: que vos ameis uns aos outros assim como eu vos amei.',
        ),
        ReadingPlanDay(
          dayNumber: 15,
          title: 'O Caminho, a Verdade e a Vida',
          passages: ['João 14'],
          focusThought: 'Não se turbe o vosso coração; credes em Deus, crede também em mim.',
        ),
        ReadingPlanDay(
          dayNumber: 16,
          title: 'A Videira Verdadeira',
          passages: ['João 15'],
          focusThought: 'Eu sou a videira, vós as varas; quem está em mim e eu nele, esse dá muito fruto.',
        ),
        ReadingPlanDay(
          dayNumber: 17,
          title: 'A Oração Sacerdotal',
          passages: ['João 17'],
          focusThought: 'A vida eterna é esta: que te conheçam a ti, o único Deus verdadeiro, e a Jesus Cristo.',
        ),
        ReadingPlanDay(
          dayNumber: 18,
          title: 'O Getsêmani e a Cruz',
          passages: ['Mateus 26'],
          focusThought: 'Pai meu, se não é possível passar de mim este cálice sem que eu o beba, faça-se a tua vontade.',
        ),
        ReadingPlanDay(
          dayNumber: 19,
          title: 'O Sacrifício e o Véu Rasgado',
          passages: ['Mateus 27'],
          focusThought: 'Está consumado! E, inclinando a cabeça, entregou o espírito.',
        ),
        ReadingPlanDay(
          dayNumber: 20,
          title: 'Ele Ressuscitou!',
          passages: ['Mateus 28'],
          focusThought: 'Ele não está aqui, porque já ressuscitou, como havia dito.',
        ),
        ReadingPlanDay(
          dayNumber: 21,
          title: 'O Caminho de Emaús e a Promessa',
          passages: ['Lucas 24'],
          focusThought: 'Eis que estou convosco todos os dias, até a consumação dos séculos.',
        ),
      ],
    ),

    // 3. Fundamentos da Fé (14 Dias)
    ReadingPlan(
      id: 'plan-fundamentos-14',
      title: 'Fundamentos da Graça',
      subtitle: '14 Dias pelas Epístolas Paulinas e Gerais',
      description:
          'Entenda a profundidade da justificação pela fé, o fruto do Espírito Santo e a esperança da glória.',
      category: 'Doutrina & Vida Cristã',
      iconName: 'heart',
      days: [
        ReadingPlanDay(
          dayNumber: 1,
          title: 'Paz com Deus e Justificação',
          passages: ['Romanos 5'],
          focusThought: 'Tendo sido, pois, justificados pela fé, temos paz com Deus por nosso Senhor Jesus Cristo.',
        ),
        ReadingPlanDay(
          dayNumber: 2,
          title: 'Nenhuma Condenação em Cristo',
          passages: ['Romanos 8'],
          focusThought: 'Quem nos separará do amor de Cristo? Em todas estas coisas somos mais do que vencedores.',
        ),
        ReadingPlanDay(
          dayNumber: 3,
          title: 'Culto Racional e Transformação da Mente',
          passages: ['Romanos 12'],
          focusThought: 'Não vos conformeis com este mundo, mas transformai-vos pela renovação do vosso entendimento.',
        ),
        ReadingPlanDay(
          dayNumber: 4,
          title: 'O Amor Supremo',
          passages: ['1 Coríntios 13'],
          focusThought: 'O amor é paciente, é benigno; agora permanecem a fé, a esperança e o amor.',
        ),
        ReadingPlanDay(
          dayNumber: 5,
          title: 'A Vitória sobre a Morte',
          passages: ['1 Coríntios 15'],
          focusThought: 'Tragada foi a morte na vitória. Onde está, ó morte, a tua vitória?',
        ),
        ReadingPlanDay(
          dayNumber: 6,
          title: 'Nova Criatura e Ministério da Reconciliação',
          passages: ['2 Coríntios 5'],
          focusThought: 'Se alguém está em Cristo, nova criatura é: as coisas velhas já passaram; eis que tudo se fez novo.',
        ),
        ReadingPlanDay(
          dayNumber: 7,
          title: 'A Graça que Basta',
          passages: ['2 Coríntios 12'],
          focusThought: 'A minha graça te basta, porque o meu poder se aperfeiçoa na fraqueza.',
        ),
        ReadingPlanDay(
          dayNumber: 8,
          title: 'O Fruto do Espírito',
          passages: ['Gálatas 5'],
          focusThought: 'Mas o fruto do Espírito é amor, alegria, paz, longanimidade, benignidade, bondade, fidelidade.',
        ),
        ReadingPlanDay(
          dayNumber: 9,
          title: 'Salvos pela Graça mediante a Fé',
          passages: ['Efésios 2'],
          focusThought: 'Porque pela graça sois salvos, por meio da fé; e isto não vem de vós, é dom de Deus.',
        ),
        ReadingPlanDay(
          dayNumber: 10,
          title: 'A Armadura de Deus',
          passages: ['Efésios 6'],
          focusThought: 'Revesti-vos de toda a armadura de Deus, para que possais estar firmes contra as astutas ciladas.',
        ),
        ReadingPlanDay(
          dayNumber: 11,
          title: 'A Alegria Inabalável e a Paz',
          passages: ['Filipenses 4'],
          focusThought: 'Tudo posso naquele que me fortalece.',
        ),
        ReadingPlanDay(
          dayNumber: 12,
          title: 'A Supremacia de Cristo',
          passages: ['Colossenses 1'],
          focusThought: 'Ele é antes de todas as coisas, e todas as coisas subsistem por ele.',
        ),
        ReadingPlanDay(
          dayNumber: 13,
          title: 'A Galeria dos Heróis da Fé',
          passages: ['Hebreus 11'],
          focusThought: 'Ora, a fé é a certeza de coisas que se esperam, a convicção de fatos que se não veem.',
        ),
        ReadingPlanDay(
          dayNumber: 14,
          title: 'Olhando Firme para Jesus',
          passages: ['Hebreus 12'],
          focusThought: 'Olhando firmemente para o Autor e Consumador da nossa fé, Jesus.',
        ),
      ],
    ),
  ];

  static ReadingPlan? getPlanById(String id) {
    for (final plan in plans) {
      if (plan.id == id) return plan;
    }
    return null;
  }
}
