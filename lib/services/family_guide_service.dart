import '../models/family_guide_model.dart';

class FamilyGuideService {
  const FamilyGuideService();

  static const List<FamilyGuideItem> _guides = [
    // The Chosen - Ep 1
    FamilyGuideItem(
      mediaId: 'the-chosen-t1-e1',
      title: 'Eu Te Chamei Pelo Nome',
      seriesTitle: 'Os Escolhidos (The Chosen)',
      keyScriptureRef: 'Isaías 43:1',
      keyScriptureText:
          'Não temas, porque eu te remi; chamei-te pelo teu nome, tu és meu.',
      debateQuestions: [
        'Como a transformação de Maria Madalena após encontrar Jesus tocou o coração de cada um de nós hoje?',
        'Em que momentos nos sentimos sozinhos ou com medo, e como a promessa de Deus em Isaías 43:1 pode nos confortar?',
        'Como podemos chamar alguém em nossa família ou escola pelo nome e demonstrar o amor de Cristo esta semana?',
      ],
      familyPrayer:
          'Senhor Jesus, obrigado por nos conhecer intimamente e nos chamar pelo nosso nome. Guarda a nossa família em Teu abraço e livra-nos de todo medo e condenação. Amém.',
      practicalChallenge:
          'Cada membro da família vai elogiar e abençoar outro membro antes de dormir dizendo: "Você é precioso para Deus e para mim".',
    ),

    // The Chosen - Ep 2
    FamilyGuideItem(
      mediaId: 'the-chosen-t1-e2',
      title: 'Shabat',
      seriesTitle: 'Os Escolhidos (The Chosen)',
      keyScriptureRef: 'Êxodo 20:8-10',
      keyScriptureText:
          'Lembra-te do dia de sábado, para o santificar. Seis dias trabalharás, e farás toda a tua obra, mas o sétimo dia é o sábado do Senhor teu Deus.',
      debateQuestions: [
        'Qual é a importância de pararmos a correria do dia a dia para descansar e agradecer a Deus em família?',
        'O que aprendemos com a mesa de comunhão retratada no episódio?',
        'O que podemos fazer juntos para tornar nossos momentos em família mais sagrados e alegres?',
      ],
      familyPrayer:
          'Pai Celeste, ensina-nos a ter pausas de adoração e paz em nossa casa. Que nosso lar seja sempre um refúgio de acolhimento e bênção. Amém.',
      practicalChallenge:
          'Realizar uma refeição em família sem telas de celular, apenas conversando sobre as bênçãos da semana.',
    ),

    // The Chosen - Ep 3
    FamilyGuideItem(
      mediaId: 'the-chosen-t1-e3',
      title: 'Jesus Ama as Criancinhas',
      seriesTitle: 'Os Escolhidos (The Chosen)',
      keyScriptureRef: 'Mateus 19:14',
      keyScriptureText:
          'Jesus, porém, disse: Deixai os pequeninos, e não os estorveis de vir a mim; porque dos tais é o reino dos céus.',
      debateQuestions: [
        'Por que Jesus valorizava tanto a pureza e a sinceridade das crianças?',
        'O que mais chamou sua atenção no jeito que Jesus conversava e ensinava com paciência?',
        'Como podemos manter uma fé simples, confiante e alegre no nosso cotidiano?',
      ],
      familyPrayer:
          'Querido Jesus, obrigado por amar as crianças e acolher a todos nós. Concede-nos a pureza de coração e a alegria de estarmos perto de Ti todos os dias. Amém.',
      practicalChallenge:
          'Fazer um desenho ou escrever uma cartinha de agradecimento a Jesus pelo Seu carinho.',
    ),

    // O Jovem Davi - Ep 1
    FamilyGuideItem(
      mediaId: 'young-david-e1',
      title: 'O Guerreiro',
      seriesTitle: 'O Jovem Davi (Young David)',
      keyScriptureRef: '1 Samuel 17:45',
      keyScriptureText:
          'Davi, porém, disse ao filisteu: Tu vens a mim com espada, e com lança, e com escudo; porém eu venho a ti em nome do Senhor dos Exércitos.',
      debateQuestions: [
        'De onde vinha a coragem de Davi mesmo quando ele enfrentava feras e perigos sozinho no campo?',
        'Quais são os "gigantes" ou medos que enfrentamos na escola, no trabalho ou em casa?',
        'Como podemos confiar mais no poder de Deus do que nas nossas próprias limitações?',
      ],
      familyPrayer:
          'Senhor dos Exércitos, dá-nos a coragem e a integridade de Davi. Que nossa confiança esteja sempre em Teu nome e na Tua fidelidade em qualquer batalha. Amém.',
      practicalChallenge:
          'Escreva num papel o seu maior medo atual, ore em família entregando-o a Deus e rasgue o papel em sinal de vitória.',
    ),

    // O Jovem Davi - Ep 2
    FamilyGuideItem(
      mediaId: 'young-david-e2',
      title: 'O Poeta',
      seriesTitle: 'O Jovem Davi (Young David)',
      keyScriptureRef: 'Salmos 19:1',
      keyScriptureText:
          'Os céus declaram a glória de Deus e o firmamento anuncia a obra das suas mãos.',
      debateQuestions: [
        'Como a música e a adoração ajudavam Davi a se conectar com Deus nas noites estreladas?',
        'Que canção ou louvor mais toca o seu coração quando você precisa de paz?',
        'Como podemos usar nossos talentos (música, palavras, arte) para glorificar a Deus?',
      ],
      familyPrayer:
          'Criador do Universo, que a nossa casa ressoe canções de louvor e gratidão. Que nossos lábios sempre Te exaltem em todas as estações da vida. Amém.',
      practicalChallenge:
          'Ouvir um louvor juntos em família e cantar de todo o coração.',
    ),

    // Bonhoeffer / Filmes
    FamilyGuideItem(
      mediaId: 'bonhoeffer-filme',
      title: 'Pastor, Espião, Mártir',
      seriesTitle: 'Bonhoeffer',
      keyScriptureRef: 'Provérbios 31:8-9',
      keyScriptureText:
          'Abre a tua boca a favor do mudo, pelo direito de todos os que se acham em desolação.',
      debateQuestions: [
        'O que significa ter uma fé viva que defende a justiça e o próximo nos momentos mais difíceis?',
        'Até que ponto estamos dispostos a nos posicionar pelo que é correto mesmo contra a maré?',
        'Como o exemplo de Dietrich Bonhoeffer inspira a nossa geração a não ser omissa?',
      ],
      familyPrayer:
          'Deus de retidão, dá-nos discernimento e coragem moral para defender a verdade e o amor de Cristo em nosso meio, sem covardia. Amém.',
      practicalChallenge:
          'Praticar uma boa ação anônima para ajudar alguém que esteja em necessidade esta semana.',
    ),

    // Seu Único Filho
    FamilyGuideItem(
      mediaId: 'his-only-son-filme',
      title: 'Seu Único Filho (His Only Son)',
      seriesTitle: 'Filmes Bíblicos & Épicos',
      keyScriptureRef: 'Hebreus 11:17-19',
      keyScriptureText:
          'Pela fé Abraão, sendo provado, ofereceu Isaque... considerando que Deus era poderoso para até dos mortos o ressuscitar.',
      debateQuestions: [
        'Qual o sentimento que você percebeu em Abraão durante a jornada ao Monte Moriá?',
        'Como a provisão do cordeiro aponta diretamente para o sacrifício de Jesus por nós?',
        'Existe algo que colocamos à frente do nosso amor por Deus? Como podemos reordenar nossas prioridades?',
      ],
      familyPrayer:
          'Pai amado, obrigado por não poupar Teu único Filho Jesus na Cruz por amor a nós. Que nossa vida seja um altar vivo de consagração a Ti. Amém.',
      practicalChallenge:
          'Agradecer a Deus em oração pelo dom inestimável da salvação e da família.',
    ),
  ];

  static const List<WorshipSongItem> _worshipCatalog = [
    WorshipSongItem(
      id: 'worship-1',
      title: 'Bondade de Deus (Goodness of God)',
      artist: 'Adoração Congregacional',
      duration: '4:55',
      lyricsSnippet:
          'Tua voz me guia em meio ao fogo\nNa escuridão Tua presença é real\nEu Te conheço como Pai e Amigo\nE eu tenho vivido na bondade de Deus...\n\nPor toda a minha vida Tu tens sido fiel\nPor toda a minha vida Tu tens sido tão, tão bom\nCom cada fôlego que eu tenho\nEu cantarei da bondade de Deus!',
      scriptureConnection: 'Salmos 23:6 • Salmos 145:9',
    ),
    WorshipSongItem(
      id: 'worship-2',
      title: 'Porque Ele Vive',
      artist: 'Hino Tradicional',
      duration: '4:15',
      lyricsSnippet:
          'Deus enviou Seu Filho amado\nPara morrer em meu lugar\nNa cruz pagou por meus pecados\nMas o sepulcro vazio está porque Ele vive!\n\nPorque Ele vive, posso crer no amanhã\nPorque Ele vive, temor não há\nMas eu bem sei, eu sei, que a minha vida\nEstá nas mãos do meu Jesus, que vivo está!',
      scriptureConnection: 'João 14:19 • 1 Coríntios 15:20',
    ),
    WorshipSongItem(
      id: 'worship-3',
      title: 'Em Teus Braços',
      artist: 'Momento Íntimo de Oração',
      duration: '5:20',
      lyricsSnippet:
          'Segura estou nos braços\nDaAquele que nunca me deixou\nSeu amor cobre minhas fraquezas\nE Sua graça me basta...\n\nEu me rendo ao Teu amor\nEu descanso em Tua paz\nTua mão me sustenta\nEm todo o tempo!',
      scriptureConnection: 'Deuteronômio 33:27 • 2 Coríntios 12:9',
    ),
    WorshipSongItem(
      id: 'worship-4',
      title: 'Quão Grande é o Meu Deus',
      artist: 'Exaltação e Glória',
      duration: '4:40',
      lyricsSnippet:
          'Esplendor de um Rei, vestido em majestade\nA Terra se alegra, a Terra se alegra\nEle envolve a luz, as trevas vão fugir\nE tremem com Sua voz...\n\nQuão grande é o meu Deus! Cantarei quão grande é o meu Deus!\nE todos hão de ver quão grande é o meu Deus!',
      scriptureConnection: 'Salmos 104:1-2 • Apocalipse 19:6',
    ),
  ];

  FamilyGuideItem? getGuideForMedia(String mediaId, {String? title}) {
    for (final guide in _guides) {
      if (guide.mediaId == mediaId) return guide;
    }
    // Match by title or fallback generic guide
    if (title != null) {
      for (final guide in _guides) {
        if (title.toLowerCase().contains(guide.title.toLowerCase()) ||
            guide.title.toLowerCase().contains(title.toLowerCase())) {
          return guide;
        }
      }
    }

    // Dynamic fallback guide tailored for Christian cinema reflection
    return FamilyGuideItem(
      mediaId: mediaId,
      title: title ?? 'Reflexão Edificante',
      seriesTitle: 'Cinema com Valores Cristãos',
      keyScriptureRef: 'Filipenses 4:8',
      keyScriptureText:
          'Quanto ao mais, irmãos, tudo o que é verdadeiro, tudo o que é honesto, tudo o que é justo, tudo o que é puro, tudo o que é amável, tudo o que é de boa fama, se há alguma virtude, e se há algum louvor, nisso pensai.',
      debateQuestions: [
        'Qual foi a cena ou ensinamento que mais chamou sua atenção nesta produção?',
        'De que maneira as atitudes dos personagens nos desafiam a agir com mais amor, justiça e fé no dia a dia?',
        'O que aprendemos sobre a fidelidade e a compaixão de Deus através desta história?',
      ],
      familyPrayer:
          'Pai Amado, obrigado por momentos em família onde podemos aprender princípios eternos. Que as lições desta história floresçam em nossos corações gerando frutos de bondade e união. Em nome de Jesus, amém.',
      practicalChallenge:
          'Compartilhar uma lição prática aprendida hoje com um amigo ou familiar.',
    );
  }

  List<FamilyGuideItem> getAllGuides() => List.unmodifiable(_guides);
  List<WorshipSongItem> getWorshipCatalog() => List.unmodifiable(_worshipCatalog);
}
