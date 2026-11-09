import 'dart:math';

class BibleTopic {
  const BibleTopic(
    this.title,
    this.description,
    this.verse,
    this.reference,
    this.queries, {
    this.detectedKeywords = const [],
    this.videoSearchTerm,
    this.songSearchTerm,
    this.podcastSearchTerm,
    this.highlightVerses = const [],
  });

  final String title;
  final String description;
  final String verse;
  final String reference;
  final List<String> queries;
  final List<String> detectedKeywords;
  final String? videoSearchTerm;
  final String? songSearchTerm;
  final String? podcastSearchTerm;
  final List<String> highlightVerses;

  String get effectiveVideoQuery =>
      videoSearchTerm ?? '$title reflexão bíblica';

  String get effectiveSongQuery =>
      songSearchTerm ?? '$title louvor';

  String get effectivePodcastQuery =>
      podcastSearchTerm ?? title;
}

const topics = <BibleTopic>[
  BibleTopic(
      'Fé',
      'Refletir sobre fé à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Hebreus 11:1',
      ['Hebreus 11', 'Hebreus 11']),
  BibleTopic(
      'Esperança',
      'Refletir sobre esperança à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Romanos 12:12',
      ['Romanos 12', 'Romanos 12']),
  BibleTopic(
      'Oração',
      'Refletir sobre oração à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      '1 Tessalonicenses 5:17',
      ['1 Tessalonicenses 5', '1 Tessalonicenses 5']),
  BibleTopic(
      'Perdão',
      'Refletir sobre perdão à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Efésios 4:32',
      ['Efésios 4', 'Efésios 4']),
  BibleTopic(
      'Amor',
      'Refletir sobre amor à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      '1 Coríntios 13:4',
      ['1 Coríntios 13', '1 Coríntios 13']),
  BibleTopic(
      'Sabedoria',
      'Refletir sobre sabedoria à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Tiago 1:5',
      ['Tiago 1', 'Tiago 1']),
  BibleTopic(
      'Gratidão',
      'Refletir sobre gratidão à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      '1 Tessalonicenses 5:18',
      ['1 Tessalonicenses 5', '1 Tessalonicenses 5']),
  BibleTopic(
      'Paz',
      'Refletir sobre paz à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'João 14:27',
      ['João 14', 'João 14']),
  BibleTopic(
      'Coragem',
      'Refletir sobre coragem à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Josué 1:9',
      ['Josué 1', 'Josué 1']),
  BibleTopic(
      'Propósito',
      'Refletir sobre propósito à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Efésios 2:10',
      ['Efésios 2', 'Efésios 2']),
  BibleTopic(
      'Família',
      'Refletir sobre família à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Colossenses 3:14',
      ['Colossenses 3', 'Colossenses 3']),
  BibleTopic(
      'Generosidade',
      'Refletir sobre generosidade à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      '2 Coríntios 9:7',
      ['2 Coríntios 9', '2 Coríntios 9']),
  BibleTopic(
      'Paciência',
      'Refletir sobre paciência à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Tiago 5:7',
      ['Tiago 5', 'Tiago 5']),
  BibleTopic(
      'Humildade',
      'Refletir sobre humildade à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Filipenses 2:3',
      ['Filipenses 2', 'Filipenses 2']),
  BibleTopic(
      'Justiça',
      'Refletir sobre justiça à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Miqueias 6:8',
      ['Miqueias 6', 'Miqueias 6']),
  BibleTopic(
      'Misericórdia',
      'Refletir sobre misericórdia à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Lucas 6:36',
      ['Lucas 6', 'Lucas 6']),
  BibleTopic(
      'Compaixão',
      'Refletir sobre compaixão à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Colossenses 3:12',
      ['Colossenses 3', 'Colossenses 3']),
  BibleTopic(
      'Obediência',
      'Refletir sobre obediência à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'João 14:15',
      ['João 14', 'João 14']),
  BibleTopic(
      'Confiança',
      'Refletir sobre confiança à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Provérbios 3:5',
      ['Provérbios 3', 'Provérbios 3']),
  BibleTopic(
      'Perseverança',
      'Refletir sobre perseverança à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Tiago 1:12',
      ['Tiago 1', 'Tiago 1']),
  BibleTopic(
      'Alegria',
      'Refletir sobre alegria à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Filipenses 4:4',
      ['Filipenses 4', 'Filipenses 4']),
  BibleTopic(
      'Bondade',
      'Refletir sobre bondade à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Gálatas 5:22',
      ['Gálatas 5', 'Gálatas 5']),
  BibleTopic(
      'Domínio próprio',
      'Refletir sobre domínio próprio à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      '2 Timóteo 1:7',
      ['2 Timóteo 1', '2 Timóteo 1']),
  BibleTopic(
      'Fidelidade',
      'Refletir sobre fidelidade à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Lamentações 3:23',
      ['Lamentações 3', 'Lamentações 3']),
  BibleTopic(
      'Santidade',
      'Refletir sobre santidade à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      '1 Pedro 1:16',
      ['1 Pedro 1', '1 Pedro 1']),
  BibleTopic(
      'Arrependimento',
      'Refletir sobre arrependimento à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Atos 3:19',
      ['Atos 3', 'Atos 3']),
  BibleTopic(
      'Reconciliação',
      'Refletir sobre reconciliação à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      '2 Coríntios 5:18',
      ['2 Coríntios 5', '2 Coríntios 5']),
  BibleTopic(
      'Unidade',
      'Refletir sobre unidade à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Efésios 4:3',
      ['Efésios 4', 'Efésios 4']),
  BibleTopic(
      'Serviço',
      'Refletir sobre serviço à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Marcos 10:45',
      ['Marcos 10', 'Marcos 10']),
  BibleTopic(
      'Discipulado',
      'Refletir sobre discipulado à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Mateus 28:19',
      ['Mateus 28', 'Mateus 28']),
  BibleTopic(
      'Evangelização',
      'Refletir sobre evangelização à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Marcos 16:15',
      ['Marcos 16', 'Marcos 16']),
  BibleTopic(
      'Adoração',
      'Refletir sobre adoração à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'João 4:24',
      ['João 4', 'João 4']),
  BibleTopic(
      'Louvor',
      'Refletir sobre louvor à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Salmos 150:6',
      ['Salmos 150', 'Salmos 150']),
  BibleTopic(
      'Jejum',
      'Refletir sobre jejum à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Mateus 6:16',
      ['Mateus 6', 'Mateus 6']),
  BibleTopic(
      'Discernimento',
      'Refletir sobre discernimento à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Filipenses 1:9',
      ['Filipenses 1', 'Filipenses 1']),
  BibleTopic(
      'Contentamento',
      'Refletir sobre contentamento à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Filipenses 4:11',
      ['Filipenses 4', 'Filipenses 4']),
  BibleTopic(
      'Integridade',
      'Refletir sobre integridade à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Provérbios 10:9',
      ['Provérbios 10', 'Provérbios 10']),
  BibleTopic(
      'Verdade',
      'Refletir sobre verdade à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'João 8:32',
      ['João 8', 'João 8']),
  BibleTopic(
      'Liberdade',
      'Refletir sobre liberdade à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Gálatas 5:1',
      ['Gálatas 5', 'Gálatas 5']),
  BibleTopic(
      'Cura interior',
      'Refletir sobre cura interior à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Salmos 147:3',
      ['Salmos 147', 'Salmos 147']),
  BibleTopic(
      'Consolo',
      'Refletir sobre consolo à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      '2 Coríntios 1:3',
      ['2 Coríntios 1', '2 Coríntios 1']),
  BibleTopic(
      'Descanso',
      'Refletir sobre descanso à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Mateus 11:28',
      ['Mateus 11', 'Mateus 11']),
  BibleTopic(
      'Renovação',
      'Refletir sobre renovação à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Romanos 12:2',
      ['Romanos 12', 'Romanos 12']),
  BibleTopic(
      'Transformação',
      'Refletir sobre transformação à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      '2 Coríntios 5:17',
      ['2 Coríntios 5', '2 Coríntios 5']),
  BibleTopic(
      'Identidade em Cristo',
      'Refletir sobre identidade em Cristo à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Gálatas 2:20',
      ['Gálatas 2', 'Gálatas 2']),
  BibleTopic(
      'Promessas de Deus',
      'Refletir sobre promessas de Deus à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      '2 Pedro 1:4',
      ['2 Pedro 1', '2 Pedro 1']),
  BibleTopic(
      'Providência',
      'Refletir sobre providência à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Mateus 6:33',
      ['Mateus 6', 'Mateus 6']),
  BibleTopic(
      'Proteção',
      'Refletir sobre proteção à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'Salmos 91:1',
      ['Salmos 91', 'Salmos 91']),
  BibleTopic(
      'Liderança servidora',
      'Refletir sobre liderança servidora à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'João 13:14',
      ['João 13', 'João 13']),
  BibleTopic(
      'Vida eterna',
      'Refletir sobre vida eterna à luz das Escrituras.',
      'Explore a passagem bíblica e reflita sobre sua aplicação.',
      'João 3:16',
      ['João 3', 'João 3']),
];

class TopicGenerator {
  TopicGenerator(this._random);
  final Random _random;
  final List<int> _remaining = [];

  static const contexts = <String>[
    'na família',
    'nas amizades',
    'no trabalho',
    'nos estudos',
    'em tempos difíceis',
    'nas decisões',
    'no cotidiano',
    'na comunidade',
    'no futuro',
    'nos relacionamentos',
    'em momentos de mudança',
    'na juventude',
    'na maturidade',
    'em novos começos',
    'diante do medo',
    'em tempos de espera',
    'ao servir o próximo',
    'em meio às dúvidas',
    'em tempos de alegria',
    'em momentos de silêncio',
    'nas pequenas escolhas',
    'durante conflitos',
    'em tempos de renovação',
    'em momentos de luto',
    'em situações de injustiça',
    'em tempos de prosperidade',
    'durante desafios financeiros',
    'na vida espiritual',
    'ao cuidar de outras pessoas',
    'ao planejar o amanhã',
  ];

  static int get totalCombinations => topics.length * (contexts.length + 1);

  BibleTopic next(BibleTopic? current) {
    if (_remaining.isEmpty) {
      _remaining.addAll(List<int>.generate(totalCombinations, (i) => i));
      _remaining.shuffle(_random);
    }
    if (_remaining.length > 1 && _titleFor(_remaining.last) == current?.title) {
      final last = _remaining.removeLast();
      _remaining.insert(0, last);
    }
    final id = _remaining.removeLast();
    final base = topics[id ~/ (contexts.length + 1)];
    final contextIndex = id % (contexts.length + 1);
    final title = contextIndex == contexts.length
        ? base.title
        : '${base.title} ${contexts[contextIndex]}';
    return BibleTopic(
      title,
      base.description,
      base.verse,
      base.reference,
      base.queries,
    );
  }

  String _titleFor(int id) {
    final base = topics[id ~/ (contexts.length + 1)];
    final index = id % (contexts.length + 1);
    return index == contexts.length
        ? base.title
        : '${base.title} ${contexts[index]}';
  }
}
