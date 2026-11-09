import 'dart:async';
import '../models/angel_model.dart';

export '../models/angel_model.dart';

class AngelService {
  const AngelService();

  static const List<String> categories = [
    'Todos',
    'The Chosen (Os Escolhidos)',
    'O Jovem Davi (Young David)',
    'Filmes Bíblicos & Épicos',
    'Família & Animação',
    'Dry Bar Comedy',
  ];

  static const List<AngelMediaItem> _catalog = [
    // 1. The Chosen (Os Escolhidos) - Temporada 1 Completa e Especiais (Gratuitos)
    AngelMediaItem(
      id: 'the-chosen-t1-e1',
      title: 'Episódio 1: Eu Te Chamei Pelo Nome',
      seriesTitle: 'Os Escolhidos (The Chosen)',
      category: 'The Chosen (Os Escolhidos)',
      description:
          'Em Cafarnaum, Maria Madalena é atormentada por demônios até que um encontro milagroso com Jesus de Nazaré transforma sua vida e identidade para sempre.',
      thumbnail: 'https://i.ytimg.com/vi/craQT09Lg7k/hqdefault.jpg',
      duration: '54 min',
      webUrl: 'https://www.angel.com/pt-BR/watch/the-chosen',
      streamId: 'craQT09Lg7k',
      badge: '100% Grátis Sem Login',
      ageRating: '12+',
      seasonNumber: 1,
      episodeNumber: 1,
    ),
    AngelMediaItem(
      id: 'the-chosen-t1-e2',
      title: 'Episódio 2: Shabat',
      seriesTitle: 'Os Escolhidos (The Chosen)',
      category: 'The Chosen (Os Escolhidos)',
      description:
          'Mateus investiga o milagre de Maria Madalena. Enquanto isso, diferentes lares judaicos celebram a noite de Shabat, refletindo sobre fé, família e redenção.',
      thumbnail: 'https://i.ytimg.com/vi/4_bK3qYQ5mE/hqdefault.jpg',
      duration: '51 min',
      webUrl: 'https://www.angel.com/pt-BR/watch/the-chosen',
      streamId: '4_bK3qYQ5mE',
      badge: '100% Grátis Sem Login',
      ageRating: '12+',
      seasonNumber: 1,
      episodeNumber: 2,
    ),
    AngelMediaItem(
      id: 'the-chosen-t1-e3',
      title: 'Episódio 3: Jesus Ama as Criancinhas',
      seriesTitle: 'Os Escolhidos (The Chosen)',
      category: 'The Chosen (Os Escolhidos)',
      description:
          'Jesus acampa nos arredores de Cafarnaum e faz amizade com um grupo de crianças locais, ensinando-lhes com paciência, amor e parábolas do Reino de Deus.',
      thumbnail: 'https://i.ytimg.com/vi/XW9_0wKqGZQ/hqdefault.jpg',
      duration: '49 min',
      webUrl: 'https://www.angel.com/pt-BR/watch/the-chosen',
      streamId: 'XW9_0wKqGZQ',
      badge: '100% Grátis Sem Login',
      ageRating: 'Livre',
      seasonNumber: 1,
      episodeNumber: 3,
    ),
    AngelMediaItem(
      id: 'the-chosen-t1-e4',
      title: 'Episódio 4: A Rocha',
      seriesTitle: 'Os Escolhidos (The Chosen)',
      category: 'The Chosen (Os Escolhidos)',
      description:
          'Desesperado com dívidas fiscais romanas, Simão Pedro passa a noite pescando sem sucesso no Mar da Galileia, até que Jesus realiza a pesca maravilhosa.',
      thumbnail: 'https://i.ytimg.com/vi/craQT09Lg7k/hqdefault.jpg',
      duration: '58 min',
      webUrl: 'https://www.angel.com/pt-BR/watch/the-chosen',
      streamId: 'craQT09Lg7k',
      badge: '100% Grátis Sem Login',
      ageRating: '12+',
      seasonNumber: 1,
      episodeNumber: 4,
    ),
    AngelMediaItem(
      id: 'the-chosen-t1-e5',
      title: 'Episódio 5: O Banquete de Casamento',
      seriesTitle: 'Os Escolhidos (The Chosen)',
      category: 'The Chosen (Os Escolhidos)',
      description:
          'Em Caná da Galileia, Jesus e seus discípulos comparecem a um casamento, onde Maria pede a ajuda do Filho e Ele opera o milagre da água transformada em vinho.',
      thumbnail: 'https://i.ytimg.com/vi/XW9_0wKqGZQ/hqdefault.jpg',
      duration: '55 min',
      webUrl: 'https://www.angel.com/pt-BR/watch/the-chosen',
      streamId: 'XW9_0wKqGZQ',
      badge: '100% Grátis Sem Login',
      ageRating: '10+',
      seasonNumber: 1,
      episodeNumber: 5,
    ),
    AngelMediaItem(
      id: 'the-chosen-t1-e6',
      title: 'Episódio 6: Inacreditável Compaixão',
      seriesTitle: 'Os Escolhidos (The Chosen)',
      category: 'The Chosen (Os Escolhidos)',
      description:
          'Jesus cura um leproso no caminho e, cercado por uma multidão fervorosa em Cafarnaum, perdoa os pecados e levanta o paralítico descido pelo teto da casa.',
      thumbnail: 'https://i.ytimg.com/vi/4_bK3qYQ5mE/hqdefault.jpg',
      duration: '52 min',
      webUrl: 'https://www.angel.com/pt-BR/watch/the-chosen',
      streamId: '4_bK3qYQ5mE',
      badge: '100% Grátis Sem Login',
      ageRating: '12+',
      seasonNumber: 1,
      episodeNumber: 6,
    ),
    AngelMediaItem(
      id: 'the-chosen-t1-e7',
      title: 'Episódio 7: Convites',
      seriesTitle: 'Os Escolhidos (The Chosen)',
      category: 'The Chosen (Os Escolhidos)',
      description:
          'Nicodemos encontra Jesus sob o manto da noite para entender o nascimento da água e do Espírito. Mateus toma a decisão radical de deixar a coletoria de impostos.',
      thumbnail: 'https://i.ytimg.com/vi/craQT09Lg7k/hqdefault.jpg',
      duration: '50 min',
      webUrl: 'https://www.angel.com/pt-BR/watch/the-chosen',
      streamId: 'craQT09Lg7k',
      badge: '100% Grátis Sem Login',
      ageRating: '10+',
      seasonNumber: 1,
      episodeNumber: 7,
    ),
    AngelMediaItem(
      id: 'the-chosen-t1-e8',
      title: 'Episódio 8: Eu Sou Ele',
      seriesTitle: 'Os Escolhidos (The Chosen)',
      category: 'The Chosen (Os Escolhidos)',
      description:
          'Jesus e seus discípulos viajam através de Samaria. Junto ao poço de Jacó, Jesus revela sua identidade messiânica a uma mulher samaritana de vida quebrantada.',
      thumbnail: 'https://i.ytimg.com/vi/XW9_0wKqGZQ/hqdefault.jpg',
      duration: '60 min',
      webUrl: 'https://www.angel.com/pt-BR/watch/the-chosen',
      streamId: 'XW9_0wKqGZQ',
      badge: '100% Grátis Sem Login',
      ageRating: '10+',
      seasonNumber: 1,
      episodeNumber: 8,
    ),
    AngelMediaItem(
      id: 'the-chosen-especial-natal',
      title: 'Especial de Natal: O Pastor',
      seriesTitle: 'Os Escolhidos (The Chosen)',
      category: 'The Chosen (Os Escolhidos)',
      description:
          'O nascimento de Jesus Cristo narrado através do olhar de um jovem pastor de ovelhas rejeitado em Belém, que testemunha a glória celestial dos anjos.',
      thumbnail: 'https://i.ytimg.com/vi/yVeoRHyuO-s/hqdefault.jpg',
      duration: '22 min',
      webUrl: 'https://www.angel.com/pt-BR/watch/the-chosen',
      streamId: 'yVeoRHyuO-s',
      badge: '100% Grátis Sem Login',
      ageRating: 'Livre',
    ),

    // 2. O Jovem Davi (Young David) - Animação Bíblica de Alto Nível
    AngelMediaItem(
      id: 'young-david-e1',
      title: 'Episódio 1: O Guerreiro',
      seriesTitle: 'O Jovem Davi (Young David)',
      category: 'O Jovem Davi (Young David)',
      description:
          'Nas colinas de Belém, o jovem Davi enfrenta feras selvagens para proteger o rebanho de seu pai, descobrindo que a verdadeira coragem vem da fé no Senhor.',
      thumbnail: 'https://i.ytimg.com/vi/A2dY2fhkC6E/hqdefault.jpg',
      duration: '15 min',
      webUrl: 'https://www.angel.com/pt-BR/watch/young-david',
      streamId: 'A2dY2fhkC6E',
      badge: '100% Grátis Sem Login',
      ageRating: 'Livre',
      episodeNumber: 1,
    ),
    AngelMediaItem(
      id: 'young-david-e2',
      title: 'Episódio 2: O Poeta',
      seriesTitle: 'O Jovem Davi (Young David)',
      category: 'O Jovem Davi (Young David)',
      description:
          'Sob a noite estrelada, Davi dedilha sua harpa e compõe salmos sinceros ao Deus Todo-Poderoso, desenvolvendo uma profunda intimidade com o Pai Celestial.',
      thumbnail: 'https://i.ytimg.com/vi/A2dY2fhkC6E/hqdefault.jpg',
      duration: '14 min',
      webUrl: 'https://www.angel.com/pt-BR/watch/young-david',
      streamId: 'A2dY2fhkC6E',
      badge: '100% Grátis Sem Login',
      ageRating: 'Livre',
      episodeNumber: 2,
    ),
    AngelMediaItem(
      id: 'young-david-e3',
      title: 'Episódio 3: O Pastor',
      seriesTitle: 'O Jovem Davi (Young David)',
      category: 'O Jovem Davi (Young David)',
      description:
          'Davi cuida das ovelhas feridas e desgarradas, vivenciando na prática o cuidado providente que inspiraria as palavras eternas do Salmo 23.',
      thumbnail: 'https://i.ytimg.com/vi/A2dY2fhkC6E/hqdefault.jpg',
      duration: '16 min',
      webUrl: 'https://www.angel.com/pt-BR/watch/young-david',
      streamId: 'A2dY2fhkC6E',
      badge: '100% Grátis Sem Login',
      ageRating: 'Livre',
      episodeNumber: 3,
    ),
    AngelMediaItem(
      id: 'young-david-e4',
      title: 'Episódio 4: O Discípulo',
      seriesTitle: 'O Jovem Davi (Young David)',
      category: 'O Jovem Davi (Young David)',
      description:
          'O profeta Samuel chega a Belém em busca do escolhido de Deus. Enquanto os irmãos mais velhos chamam a atenção pela aparência, Deus olha para o coração de Davi.',
      thumbnail: 'https://i.ytimg.com/vi/A2dY2fhkC6E/hqdefault.jpg',
      duration: '18 min',
      webUrl: 'https://www.angel.com/pt-BR/watch/young-david',
      streamId: 'A2dY2fhkC6E',
      badge: '100% Grátis Sem Login',
      ageRating: 'Livre',
      episodeNumber: 4,
    ),
    AngelMediaItem(
      id: 'young-david-e5',
      title: 'Episódio 5: O Rei',
      seriesTitle: 'O Jovem Davi (Young David)',
      category: 'O Jovem Davi (Young David)',
      description:
          'Ungido para um propósito supremo, Davi assume a responsabilidade de honrar a Deus perante gigantes, reis e nações inteiras.',
      thumbnail: 'https://i.ytimg.com/vi/A2dY2fhkC6E/hqdefault.jpg',
      duration: '19 min',
      webUrl: 'https://www.angel.com/pt-BR/watch/young-david',
      streamId: 'A2dY2fhkC6E',
      badge: '100% Grátis Sem Login',
      ageRating: 'Livre',
      episodeNumber: 5,
    ),

    // 3. Filmes Bíblicos & Épicos da Fé
    AngelMediaItem(
      id: 'his-only-son',
      title: 'Seu Único Filho (His Only Son)',
      seriesTitle: 'Filme Bíblico Épico',
      category: 'Filmes Bíblicos & Épicos',
      description:
          'Uma jornada comovente pela fé de Abraão enquanto ele viaja por três dias até o Monte Moriá para o sacrifício de Isaque, apontando para o sacrifício supremo de Cristo.',
      thumbnail: 'https://i.ytimg.com/vi/XW9_0wKqGZQ/hqdefault.jpg',
      duration: '1h 46m',
      webUrl: 'https://www.angel.com/pt-BR/watch/his-only-son',
      streamId: 'XW9_0wKqGZQ',
      badge: '100% Grátis Sem Login',
      ageRating: '12+',
    ),
    AngelMediaItem(
      id: 'bonhoeffer',
      title: 'Bonhoeffer: Pastor. Espião. Assassino.',
      seriesTitle: 'Documentário & Prévia Épica',
      category: 'Filmes Bíblicos & Épicos',
      description:
          'A dramática e inspiradora história de Dietrich Bonhoeffer, o pastor e teólogo que resistiu com bravura e fé cristã inabalável contra o regime tirânico nazista.',
      thumbnail: 'https://i.ytimg.com/vi/gy9bgu_JW84/hqdefault.jpg',
      duration: '28 min',
      webUrl: 'https://www.angel.com/pt-BR/watch/bonhoeffer',
      streamId: 'gy9bgu_JW84',
      badge: '100% Grátis Sem Login',
      ageRating: '14+',
    ),
    AngelMediaItem(
      id: 'cabrini',
      title: 'Cabrini (Vida & Legado)',
      seriesTitle: 'Filme Inspirador',
      category: 'Filmes Bíblicos & Épicos',
      description:
          'Francesca Cabrini luta contra as adversidades de Nova York no final do século XIX para construir um império de esperança, compaixão e hospitais para os excluídos.',
      thumbnail: 'https://i.ytimg.com/vi/gy9bgu_JW84/hqdefault.jpg',
      duration: '35 min',
      webUrl: 'https://www.angel.com/pt-BR/watch/cabrini',
      streamId: 'gy9bgu_JW84',
      badge: '100% Grátis Sem Login',
      ageRating: '12+',
    ),
    AngelMediaItem(
      id: 'after-death',
      title: 'Depois da Morte (After Death)',
      seriesTitle: 'Investigação da Fé',
      category: 'Filmes Bíblicos & Épicos',
      description:
          'Uma exploração comovente baseada em relatos reais de quase-morte e dados científicos de ponta, trazendo esperança e reflexão sobre a vida eterna e o Céu.',
      thumbnail: 'https://i.ytimg.com/vi/HxBeDiX5cXE/hqdefault.jpg',
      duration: '42 min',
      webUrl: 'https://www.angel.com/pt-BR/watch/after-death',
      streamId: 'HxBeDiX5cXE',
      badge: '100% Grátis Sem Login',
      ageRating: '10+',
    ),
    AngelMediaItem(
      id: 'sound-of-freedom-doc',
      title: 'Som da Liberdade: Especial de Bastidores',
      seriesTitle: 'Documentário de Esperança',
      category: 'Filmes Bíblicos & Épicos',
      description:
          'Os bastidores reais e o movimento que mobilizou milhões de pessoas ao redor do globo em defesa das crianças e da dignidade humana.',
      thumbnail: 'https://i.ytimg.com/vi/HxBeDiX5cXE/hqdefault.jpg',
      duration: '32 min',
      webUrl: 'https://www.angel.com/pt-BR/watch/sound-of-freedom',
      streamId: 'HxBeDiX5cXE',
      badge: '100% Grátis Sem Login',
      ageRating: '14+',
    ),
    AngelMediaItem(
      id: 'david-movie-preview',
      title: 'David (O Filme Épico de Animação): Prévia Exclusiva',
      seriesTitle: 'Superprodução Bíblica',
      category: 'Filmes Bíblicos & Épicos',
      description:
          'Prévia oficial e bastidores da maior animação bíblica de todos os tempos, contando a ascensão do humilde pastor ao trono de Israel.',
      thumbnail: 'https://i.ytimg.com/vi/A2dY2fhkC6E/hqdefault.jpg',
      duration: '12 min',
      webUrl: 'https://www.angel.com/pt-BR/watch/david',
      streamId: 'A2dY2fhkC6E',
      badge: '100% Grátis Sem Login',
      ageRating: 'Livre',
    ),

    // 4. Família & Animação
    AngelMediaItem(
      id: 'wingfeather-e1',
      title: 'Episódio 1: A Noite dos Dragões do Mar',
      seriesTitle: 'A Saga Asa de Pena (The Wingfeather Saga)',
      category: 'Família & Animação',
      description:
          'Os irmãos Igiby enfrentam perigos no misterioso mundo de Aerwiar e descobrem um segredo de família que testará sua fé, coragem e união.',
      thumbnail: 'https://i.ytimg.com/vi/j-mDhg3Dpyc/hqdefault.jpg',
      duration: '26 min',
      webUrl: 'https://www.angel.com/pt-BR/watch/the-wingfeather-saga',
      streamId: 'j-mDhg3Dpyc',
      badge: '100% Grátis Sem Login',
      ageRating: '10+',
      episodeNumber: 1,
    ),
    AngelMediaItem(
      id: 'wingfeather-e2',
      title: 'Episódio 2: A Ilha de Anniera',
      seriesTitle: 'A Saga Asa de Pena (The Wingfeather Saga)',
      category: 'Família & Animação',
      description:
          'Janner e Tink descobrem a história da lendária terra de Anniera e percebem que a honra e o amor à verdade exigem sacrifício pessoal.',
      thumbnail: 'https://i.ytimg.com/vi/j-mDhg3Dpyc/hqdefault.jpg',
      duration: '24 min',
      webUrl: 'https://www.angel.com/pt-BR/watch/the-wingfeather-saga',
      streamId: 'j-mDhg3Dpyc',
      badge: '100% Grátis Sem Login',
      ageRating: '10+',
      episodeNumber: 2,
    ),
    AngelMediaItem(
      id: 'tuttle-twins-e1',
      title: 'Episódio 1: A Máquina do Tempo e a Liberdade',
      seriesTitle: 'Os Gêmeos Tuttle (Tuttle Twins)',
      category: 'Família & Animação',
      description:
          'Ethan e Emily viajam no tempo com a vovó Gabby para aprender lições eternas sobre livre-arbítrio, justiça e escolhas responsáveis.',
      thumbnail: 'https://i.ytimg.com/vi/j-mDhg3Dpyc/hqdefault.jpg',
      duration: '22 min',
      webUrl: 'https://www.angel.com/pt-BR/watch/tuttle-twins',
      streamId: 'j-mDhg3Dpyc',
      badge: '100% Grátis Sem Login',
      ageRating: 'Livre',
      episodeNumber: 1,
    ),
    AngelMediaItem(
      id: 'tuttle-twins-e2',
      title: 'Episódio 2: O Valor do Trabalho e Honestidade',
      seriesTitle: 'Os Gêmeos Tuttle (Tuttle Twins)',
      category: 'Família & Animação',
      description:
          'Os gêmeos descobrem que o trabalho honesto e o serviço ao próximo são bênçãos fundamentais para a construção de um lar próspero e alegre.',
      thumbnail: 'https://i.ytimg.com/vi/j-mDhg3Dpyc/hqdefault.jpg',
      duration: '21 min',
      webUrl: 'https://www.angel.com/pt-BR/watch/tuttle-twins',
      streamId: 'j-mDhg3Dpyc',
      badge: '100% Grátis Sem Login',
      ageRating: 'Livre',
      episodeNumber: 2,
    ),

    // 5. Dry Bar Comedy - Humor Limpo e Saudável
    AngelMediaItem(
      id: 'dry-bar-familia',
      title: 'Especial Família Limpa: Melhores Momentos',
      seriesTitle: 'Dry Bar Comedy',
      category: 'Dry Bar Comedy',
      description:
          'Uma seleção hilária de comédia stand-up 100% limpa e segura, onde pais e filhos podem rir juntos sem constrangimentos ou palavrões.',
      thumbnail: 'https://i.ytimg.com/vi/HxBeDiX5cXE/hqdefault.jpg',
      duration: '38 min',
      webUrl: 'https://www.angel.com/pt-BR/watch/dry-bar-comedy',
      streamId: 'HxBeDiX5cXE',
      badge: '100% Grátis Sem Login',
      ageRating: 'Livre',
    ),
    AngelMediaItem(
      id: 'dry-bar-risos',
      title: 'Risos com Propósito: Casamento e Cotidiano',
      seriesTitle: 'Dry Bar Comedy',
      category: 'Dry Bar Comedy',
      description:
          'Histórias cômicas e bem-humoradas sobre os desafios da vida a dois, criação de filhos e peripécias da vida familiar moderna.',
      thumbnail: 'https://i.ytimg.com/vi/HxBeDiX5cXE/hqdefault.jpg',
      duration: '44 min',
      webUrl: 'https://www.angel.com/pt-BR/watch/dry-bar-comedy',
      streamId: 'HxBeDiX5cXE',
      badge: '100% Grátis Sem Login',
      ageRating: 'Livre',
    ),
  ];

  List<AngelMediaItem> getCatalog() => List.unmodifiable(_catalog);

  AngelMediaItem get featured => _catalog.first;

  Future<List<AngelMediaItem>> fetchFreeCatalog() async {
    // Simula carregamento resiliente com garantia de resposta imediata
    return _catalog;
  }

  List<AngelMediaItem> getByCategory(String category) {
    if (category == 'Todos' || category.isEmpty) {
      return _catalog;
    }
    return _catalog.where((item) => item.category == category).toList();
  }

  List<AngelMediaItem> search(String query) {
    final clean = query.trim().toLowerCase();
    if (clean.isEmpty) return _catalog;

    return _catalog.where((item) {
      return item.title.toLowerCase().contains(clean) ||
          item.seriesTitle.toLowerCase().contains(clean) ||
          item.category.toLowerCase().contains(clean) ||
          item.description.toLowerCase().contains(clean);
    }).toList();
  }
}
