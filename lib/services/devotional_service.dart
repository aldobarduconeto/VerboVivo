import '../models/devotional_model.dart';

class DevotionalService {
  const DevotionalService();

  static final List<DevotionalModel> _curatedDevotionals = [
    DevotionalModel(
      id: 'dev-1',
      date: DateTime(2026, 1, 1),
      title: 'A Paz que Excede todo o Entendimento',
      theme: 'Paz & Ansiedade',
      scriptureReference: 'Filipenses 4:6-7',
      scriptureText:
          'Não andeis ansiosos de coisa alguma; antes, as vossas petições sejam plenamente conhecidas diante de Deus, por meio de oração e súplica, com ação de graças. E a paz de Deus, que excede todo o entendimento, guardará os vossos corações e os vossos pensamentos em Cristo Jesus.',
      reflection:
          'Em dias agitados e cheios de incertezas, o nosso primeiro reflexo costuma ser a preocupação. No entanto, o apóstolo Paulo nos convida a transformar a ansiedade em oração sincera. Quando descarregamos nossas inquietações nos braços do Pai e agradecemos pelo que Ele já fez, uma paz sobrenatural preenche os espaços vazios e acalma as tempestades interiores.',
      prayer:
          'Senhor Jesus, hoje entrego em Tuas mãos todas as minhas preocupações, planos e receios. Ensina-me a descansar em Tua providência e guarda o meu coração com a Tua maravilhosa paz que vai além de toda compreensão humana. Amém.',
      practicalAction:
          'Identifique um motivo de preocupação hoje e faça uma oração de entrega, agradecendo por 3 bênçãos já recebidas esta semana.',
    ),
    DevotionalModel(
      id: 'dev-2',
      date: DateTime(2026, 1, 2),
      title: 'Renovados pela Misericórdia',
      theme: 'Esperança & Renovo',
      scriptureReference: 'Lamentações 3:22-23',
      scriptureText:
          'As misericórdias do Senhor são a causa de não sermos consumidos, porque as suas misericórdias não têm fim; renovam-se cada manhã; grande é a tua fidelidade.',
      reflection:
          'Não importa o que aconteceu no dia de ontem, o nascer do sol traz consigo uma torrente inesgotável da graça divina. Deus não nos trata segundo os nossos tropeços, mas segundo o Seu amor infinito. Cada manhã é uma nova folha em branco assinada pela fidelidade de Deus para você recomeçar com fé.',
      prayer:
          'Pai Celeste, sou grato porque Tua misericórdia é nova sobre mim hoje. Apaga os pesos do passado e concede-me ânimo renovado para caminhar em fidelidade e alegria sob a Tua direção. Em nome de Jesus, amém.',
      practicalAction:
          'Perdoe a si mesmo por uma falha recente e decida começar este dia com um sorriso e gratidão.',
    ),
    DevotionalModel(
      id: 'dev-3',
      date: DateTime(2026, 1, 3),
      title: 'O Bom Pastor que Tudo Provê',
      theme: 'Confiança & Provisão',
      scriptureReference: 'Salmos 23:1-3',
      scriptureText:
          'O Senhor é o meu pastor; nada me faltará. Ele me faz repousar em pastos verdejantes; leva-me para junto das águas de descanso; refrigera a minha alma.',
      reflection:
          'Davi conhecia a rotina de um pastor. Ele sabia que as ovelhas não precisam planejar o pasto nem procurar o riacho; elas apenas confiam no cuidado do pastor. Quando Jesus é o nosso Guia, não precisamos nos desesperar sobre o amanhã. Ele sabe do que precisamos antes mesmo de pedirmos e nos conduz a águas tranquilas.',
      prayer:
          'Amado Pastor da minha alma, reconheço a Tua soberania sobre a minha vida. Afasta de mim o medo da escassez e guia os meus passos por caminhos de justiça e descanso espiritual. Amém.',
      practicalAction:
          'Reserve 5 minutos de silêncio para meditar na bondade do Senhor e ouvir a Sua voz.',
    ),
    DevotionalModel(
      id: 'dev-4',
      date: DateTime(2026, 1, 4),
      title: 'Força na Fraqueza',
      theme: 'Superação & Graça',
      scriptureReference: '2 Coríntios 12:9',
      scriptureText:
          'E disse-me: A minha graça te basta, porque o meu poder se aperfeiçoa na fraqueza. De boa vontade, pois, me gloriarei nas minhas fraquezas, para que em mim habite o poder de Cristo.',
      reflection:
          'Nossa cultura celebra apenas a autossuficiência e a invulnerabilidade. Mas no Reino de Deus, o reconhecimento da nossa limitação é a porta de entrada para a manifestação do poder do Espírito Santo. Quando chegamos ao fim dos nossos próprios recursos, descobrimos que a graça de Deus é mais que suficiente.',
      prayer:
          'Deus Todo-Poderoso, confesso que sozinho não consigo superar todos os desafios. Que a Tua graça se manifeste com poder onde faltam as minhas forças humanas, para a Tua glória. Amém.',
      practicalAction:
          'Em vez de reclamar de uma limitação, declare hoje que o poder de Deus é aperfeiçoado nela.',
    ),
    DevotionalModel(
      id: 'dev-5',
      date: DateTime(2026, 1, 5),
      title: 'Lâmpada para os Meus Pés',
      theme: 'Palavra & Direção',
      scriptureReference: 'Salmos 119:105',
      scriptureText:
          'Lâmpada para os meus pés é a tua palavra e luz, para o meu caminho.',
      reflection:
          'A lâmpada nos tempos bíblicos iluminava apenas o próximo passo, não a estrada inteira de uma vez. Deus deseja que caminhemos em dependência diária da Sua Palavra. Quando lemos as Escrituras com coração aberto, recebemos clareza para a próxima decisão e sabedoria para evitar os tropeços da vida.',
      prayer:
          'Senhor, que a Tua Palavra seja o guia supremo de todas as minhas escolhas, pensamentos e conversas hoje. Dá-me sede constante de Te conhecer mais pelas Escrituras. Amém.',
      practicalAction:
          'Escolha um versículo bíblico hoje, anote-o em um papel ou no celular e leia-o 3 vezes ao longo do dia.',
    ),
    DevotionalModel(
      id: 'dev-6',
      date: DateTime(2026, 1, 6),
      title: 'O Amor que Nunca Falha',
      theme: 'Amor & Relacionamentos',
      scriptureReference: '1 Coríntios 13:4-7',
      scriptureText:
          'O amor é paciente, é benigno; o amor não arde em ciúmes, não se ufana, não se ensoberbe... tudo sofre, tudo crê, tudo espera, tudo suporta.',
      reflection:
          'Amar quando tudo vai bem é simples; o verdadeiro amor divino se prova na paciência com os erros alheios e na disposição de perdoar. Fomos amados por Deus primeiro, de forma incondicional e sacrificial na Cruz. Hoje, somos chamados a transbordar esse mesmo amor com quem convive ao nosso redor.',
      prayer:
          'Pai de amor, enche meu coração com o Teu amor genuíno. Livra-me do egoísmo e da irritação fácil. Que minhas palavras e atitudes hoje sejam fontes de reconciliação e acolhimento. Amém.',
      practicalAction:
          'Demonstre paciência ativa com alguém que normalmente testa sua calma hoje.',
    ),
    DevotionalModel(
      id: 'dev-7',
      date: DateTime(2026, 1, 7),
      title: 'Coragem Diante dos Gigantes',
      theme: 'Fé & Ousadia',
      scriptureReference: 'Josué 1:9',
      scriptureText:
          'Não to mandei eu? Sê forte e corajoso; não temas, nem te espantes, porque o Senhor, teu Deus, é contigo por onde quer que andares.',
      reflection:
          'A ordem de Deus para Josué não dependia da força física do líder, mas da promessa da companhia divina. O medo tenta nos paralisar apontando o tamanho dos problemas; a fé nos coloca em movimento lembrando da grandeza dAquele que caminha conosco. Seja forte, o Senhor já vai à sua frente.',
      prayer:
          'Deus bendito, expulsa todo temor e insegurança do meu espírito. Sei que onde eu for, a Tua presença estará comigo. Concede-me coragem para dar passos ousados na Tua vontade. Amém.',
      practicalAction:
          'Enfrente hoje aquela conversa ou tarefa adiada por medo, confiando na presença de Deus.',
    ),
  ];

  DevotionalModel getDevotionalForDate(DateTime date) {
    // Computes day of year to cycle through rich devotionals deterministically
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    final index = dayOfYear % _curatedDevotionals.length;
    final template = _curatedDevotionals[index];

    return DevotionalModel(
      id: 'dev-${date.year}-${date.month}-${date.day}',
      date: date,
      title: template.title,
      theme: template.theme,
      scriptureReference: template.scriptureReference,
      scriptureText: template.scriptureText,
      reflection: template.reflection,
      prayer: template.prayer,
      practicalAction: template.practicalAction,
      author: template.author,
    );
  }

  List<DevotionalModel> getAllCurated() => List.unmodifiable(_curatedDevotionals);
}
