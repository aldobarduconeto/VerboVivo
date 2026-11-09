import 'dart:math';
import '../models/topic_model.dart';
import 'bible_service.dart';

class _ThemeDefinition {
  const _ThemeDefinition({
    required this.name,
    required this.searchTag,
    required this.keywords,
    required this.chapters,
    required this.keyVerse,
  });

  final String name;
  final String searchTag;
  final List<String> keywords;
  final List<String> chapters;
  final String keyVerse;
}

class TopicRecommendationService {
  const TopicRecommendationService();

  static const List<_ThemeDefinition> _themes = [
    // 1. Perdão a si mesmo e superação da culpa
    _ThemeDefinition(
      name: 'Perdão a Si Mesmo e Cura da Culpa',
      searchTag: 'perdao a si mesmo superar culpa',
      keywords: [
        'perdao a si mesmo', 'perdoar a si mesmo', 'autoperdao', 'auto perdao',
        'culpa', 'culpado', 'culpada', 'sentimento de culpa', 'remorso',
        'me culpo', 'nao me perdoo', 'nao consigo me perdoar', 'autocondenaçao',
        'autocondenacao', 'auto acusacao', 'autoacusacao', 'passado', 'vergonha',
        'peso na consciencia', 'auto perdoar', 'perdoar meu passado', 'me perdoar',
        'aceitar o perdao', 'superar o passado',
      ],
      chapters: [
        'Romanos 8', '1 João 1', '1 João 3', 'Salmos 103', 'Salmos 32',
        'Salmos 51', '2 Coríntios 5', 'Filipenses 3', 'Isaías 43',
        'Hebreus 10', 'Miqueias 7', 'Salmos 130',
      ],
      keyVerse: 'Portanto, agora nenhuma condenação há para os que estão em Cristo Jesus. (Romanos 8:1)',
    ),

    // 2. Amor próprio, autoestima e identidade em Deus
    _ThemeDefinition(
      name: 'Amor Próprio e Autoestima em Deus',
      searchTag: 'amor proprio autoestima identidade cristo',
      keywords: [
        'amor proprio', 'amor a si mesmo', 'autoestima', 'auto estima',
        'me amar', 'gostar de mim', 'valor proprio', 'autoimagem', 'auto imagem',
        'me aceitar', 'inseguranca com aparencia', 'sentir inferior', 'inferioridade',
        'comparacao', 'identidade em cristo', 'filho de deus', 'valor em deus',
        'dignidade', 'precioso para deus', 'rejeicao a si mesmo',
      ],
      chapters: [
        'Salmos 139', 'Efésios 1', '1 Pedro 2', '1 João 3', 'Romanos 8',
        'Gálatas 2', 'Isaías 43', 'Sofonias 3', 'Lucas 12', 'Mateus 10',
        '2 Coríntios 12', 'Salmos 8',
      ],
      keyVerse: 'Eu te louvarei, porque de um modo tão admirável e maravilhoso fui formado; maravilhosas são as tuas obras. (Salmos 139:14)',
    ),

    // 3. Redenção e Graça Restauradora
    _ThemeDefinition(
      name: 'Redenção e Graça Restauradora',
      searchTag: 'redencao graca cruz de cristo',
      keywords: [
        'redencao', 'redimido', 'redimida', 'resgatado', 'resgatada',
        'salvacao', 'salvo', 'graca', 'sangue de jesus', 'cruz',
        'comprado por preco', 'novo nascimento', 'nova criatura',
        'liberto da escravidao', 'justificacao', 'justificado', 'restaurado',
      ],
      chapters: [
        'Efésios 1', 'Colossenses 1', 'Romanos 5', 'Romanos 8', 'Gálatas 3',
        'Tito 2', '2 Coríntios 5', 'Isaías 53', 'Hebreus 9', '1 Pedro 1',
        'Salmos 130',
      ],
      keyVerse: 'Em quem temos a redenção pelo seu sangue, a remissão das ofensas, segundo as riquezas da sua graça. (Efésios 1:7)',
    ),

    // 4. Ansiedade e Aflição
    _ThemeDefinition(
      name: 'Ansiedade e Aflição',
      searchTag: 'ansiedade paz tranquilidade',
      keywords: [
        'ansiedade', 'ansioso', 'ansiosa', 'preocupacao', 'preocupado', 'preocupada',
        'estresse', 'estressado', 'estressada', 'panico', 'angustia', 'angustiado',
        'angustiada', 'aflito', 'aflita', 'aflicao', 'sufoco', 'desespero', 'agonia',
        'insonia', 'sobrecarregado', 'sobrecarregada', 'pressao', 'nervosismo',
      ],
      chapters: ['Filipenses 4', 'Mateus 6', '1 Pedro 5', 'Salmos 94', 'Salmos 42', 'Salmos 55', 'João 14', 'Salmos 34', 'Salmos 23'],
      keyVerse: 'Não andeis ansiosos de coisa alguma; antes, as vossas petições sejam conhecidas diante de Deus. (Filipenses 4:6)',
    ),

    // 5. Medo e Insegurança
    _ThemeDefinition(
      name: 'Medo e Insegurança',
      searchTag: 'vencer o medo coragem confianca',
      keywords: [
        'medo', 'temor', 'temeroso', 'inseguranca', 'inseguro', 'insegura', 'pavor',
        'assustado', 'assustada', 'ameaca', 'covardia', 'incerteza', 'perigo',
      ],
      chapters: ['Isaías 41', 'Salmos 27', 'Salmos 91', '2 Timóteo 1', 'Josué 1', 'Salmos 56', 'Salmos 23', 'Salmos 118', 'Salmos 46', 'Romanos 8'],
      keyVerse: 'Não temas, porque eu sou contigo; não te assombres, porque eu sou o teu Deus. (Isaías 41:10)',
    ),

    // 6. Tristeza e Depressão
    _ThemeDefinition(
      name: 'Tristeza e Depressão',
      searchTag: 'superar tristeza consolo cura da alma',
      keywords: [
        'tristeza', 'triste', 'depressao', 'deprimido', 'deprimida', 'desanimo',
        'desanimado', 'desanimada', 'choro', 'chorar', 'dor na alma', 'vazio',
        'desamparo', 'desalento', 'abatido', 'abatida', 'desgosto', 'lamento',
      ],
      chapters: ['Salmos 42', 'Salmos 34', 'Salmos 43', '2 Coríntios 1', 'Mateus 11', '1 Reis 19', 'Salmos 147', 'Romanos 8', 'Salmos 30', 'Lamentações 3'],
      keyVerse: 'Perto está o Senhor dos que têm o coração quebrantado e salva os de espírito contrito. (Salmos 34:18)',
    ),

    // 7. Luto e Perda
    _ThemeDefinition(
      name: 'Luto e Perda',
      searchTag: 'consolo no luto esperanca',
      keywords: [
        'luto', 'perda', 'perdi', 'faleceu', 'falecimento', 'morte', 'morrer',
        'enterro', 'saudade', 'orfao', 'viuva', 'partida', 'ente querido',
      ],
      chapters: ['Salmos 34', 'João 11', 'Apocalipse 21', '2 Coríntios 1', 'Salmos 23', '1 Tessalonicenses 4', 'Isaías 40', 'Romanos 8'],
      keyVerse: 'E Deus limpará de seus olhos toda a lágrima; e não haverá mais morte, nem pranto, nem dor. (Apocalipse 21:4)',
    ),

    // 8. Solidão e Rejeição
    _ThemeDefinition(
      name: 'Solidão e Rejeição',
      searchTag: 'solidao presenca de deus acolhimento',
      keywords: [
        'solidao', 'sozinho', 'sozinha', 'rejeicao', 'rejeitado', 'rejeitada',
        'abandono', 'abandonado', 'abandonada', 'desamparo', 'desprezado',
        'incompreendido', 'isolado', 'isolamento',
      ],
      chapters: ['Salmos 139', 'Salmos 23', 'Isaías 41', 'Hebreus 13', 'Mateus 28', 'João 14', 'Salmos 27', 'Deuteronômio 31'],
      keyVerse: 'Não te deixarei, nem te desampararei. (Hebreus 13:5)',
    ),

    // 9. Trabalho e Carreira
    _ThemeDefinition(
      name: 'Trabalho e Carreira',
      searchTag: 'trabalho sabedoria profissao proposito',
      keywords: [
        'trabalho', 'emprego', 'desemprego', 'desempregado', 'desempregada',
        'carreira', 'profissao', 'empresa', 'negocio', 'negocios', 'chefe',
        'colegas', 'estudo', 'estudos', 'faculdade', 'prova', 'concurso',
        'entrevista', 'profissional', 'vocacao',
      ],
      chapters: ['Colossenses 3', 'Provérbios 16', 'Provérbios 3', 'Mateus 6', 'Eclesiastes 3', 'Salmos 90', 'Salmos 128', 'Efésios 6', '2 Tessalonicenses 3'],
      keyVerse: 'Tudo quanto fizerdes, fazei-o de todo o coração, como ao Senhor e não aos homens. (Colossenses 3:23)',
    ),

    // 10. Finanças e Provisão
    _ThemeDefinition(
      name: 'Finanças e Provisão',
      searchTag: 'financas provisao de deus prosperidade',
      keywords: [
        'financas', 'financeiro', 'financeira', 'dinheiro', 'divida', 'dividas',
        'endividado', 'despesas', 'contas', 'falta de dinheiro', 'crise financeira',
        'pobreza', 'sustento', 'provisao', 'providencia', 'prosperidade',
        'dizimo', 'oferta', 'salario',
      ],
      chapters: ['Mateus 6', 'Provérbios 3', 'Filipenses 4', '1 Timóteo 6', '2 Coríntios 9', 'Salmos 23', 'Salmos 37', 'Lucas 12', 'Malaquias 3'],
      keyVerse: 'O meu Deus, segundo as suas riquezas, suprirá todas as vossas necessidades. (Filipenses 4:19)',
    ),

    // 11. Casamento e Casal
    _ThemeDefinition(
      name: 'Casamento e Casal',
      searchTag: 'casamento familia cristao restauracao',
      keywords: [
        'casamento', 'esposo', 'esposa', 'marido', 'mulher', 'casal',
        'conjuge', 'matrimonio', 'divorcio', 'separacao', 'traicao',
        'noivado', 'namoro', 'briga de casal', 'relacionamento amoroso',
      ],
      chapters: ['Efésios 5', '1 Coríntios 13', 'Gênesis 2', 'Colossenses 3', '1 Pedro 3', 'Provérbios 31', 'Cânticos 2', 'Eclesiastes 4', 'Mateus 19'],
      keyVerse: 'O amor é paciente, o amor é bondoso. Não inveja, não se vangloria, não se orgulha. (1 Coríntios 13:4)',
    ),

    // 12. Família e Filhos
    _ThemeDefinition(
      name: 'Família e Filhos',
      searchTag: 'familia educacao filhos lar',
      keywords: [
        'familia', 'filho', 'filhos', 'filha', 'filhas', 'mae', 'pai', 'pais',
        'maternidade', 'paternidade', 'lar', 'casa', 'parentes', 'irmao', 'irmaos',
        'educacao dos filhos', 'adolescente', 'crianca',
      ],
      chapters: ['Efésios 6', 'Salmos 127', 'Salmos 128', 'Provérbios 22', 'Josué 24', 'Colossenses 3', 'Deuteronômio 6', 'Provérbios 1'],
      keyVerse: 'Eu e a minha casa serviremos ao Senhor. (Josué 24:15)',
    ),

    // 13. Perdão ao Próximo e Reconciliação
    _ThemeDefinition(
      name: 'Perdão ao Próximo e Reconciliação',
      searchTag: 'perdao reconciliacao ofensa relacionamentos',
      keywords: [
        'perdao', 'perdoar', 'perdoei', 'magoa', 'magoado', 'magoada',
        'rancor', 'ressentimento', 'ofensa', 'ofendido', 'ofendida',
        'raiva', 'vinganca', 'reconciliacao', 'desculpas', 'liberar perdao',
        'perdoar meu irmao', 'perdoar o outro',
      ],
      chapters: ['Mateus 18', 'Efésios 4', 'Colossenses 3', 'Mateus 6', 'Lucas 15', 'Salmos 103', 'Gênesis 50', 'Romanos 12'],
      keyVerse: 'Sede uns para com os outros benignos, compassivos, perdoando-vos uns aos outros, como Deus vos perdoou em Cristo. (Efésios 4:32)',
    ),

    // 14. Paciência e Controle Emocional
    _ThemeDefinition(
      name: 'Paciência e Controle Emocional',
      searchTag: 'paciencia dominio proprio mansidao',
      keywords: [
        'raiva', 'ira', 'furia', 'irritacao', 'irritado', 'irritada', 'briga',
        'brigas', 'conflito', 'paciencia', 'impaciencia', 'tolerancia',
        'calma', 'mansidao', 'autocontrole', 'dominio proprio',
      ],
      chapters: ['Provérbios 15', 'Tiago 1', 'Efésios 4', 'Provérbios 16', 'Gálatas 5', 'Salmos 37', 'Colossenses 3', 'Provérbios 25'],
      keyVerse: 'A resposta branda desvia o furor, mas a palavra dura suscita a ira. (Provérbios 15:1)',
    ),

    // 15. Saúde e Cura
    _ThemeDefinition(
      name: 'Saúde e Cura',
      searchTag: 'cura enfermidade oracao saude',
      keywords: [
        'saude', 'cura', 'curar', 'doenca', 'doente', 'enfermidade', 'enfermo',
        'enferma', 'hospital', 'dor fisica', 'cirurgia', 'remedio', 'tratamento',
        'milagre', 'cancer', 'diagnostico',
      ],
      chapters: ['Tiago 5', 'Salmos 103', 'Isaías 53', 'Jeremias 17', 'Salmos 41', 'Mateus 8', 'Lucas 8', 'Êxodo 15', 'Salmos 30'],
      keyVerse: 'Ele é quem perdoa todas as tuas iniquidades e sara todas as tuas enfermidades. (Salmos 103:3)',
    ),

    // 16. Fé e Confiança
    _ThemeDefinition(
      name: 'Fé e Confiança',
      searchTag: 'fe confianca em deus crer',
      keywords: [
        'fe', 'crer', 'acreditar', 'duvida', 'incredulidade', 'confianca',
        'confiar', 'esperar', 'espera', 'tempo de deus', 'promessa', 'promessas',
        'fidelidade', 'impossivel',
      ],
      chapters: ['Hebreus 11', 'Romanos 10', 'Tiago 1', 'Marcos 9', 'Salmos 27', 'Provérbios 3', 'Salmos 40', 'Isaías 40', 'Habacuque 3'],
      keyVerse: 'Ora, a fé é o firme fundamento das coisas que se esperam, e a prova das coisas que se não veem. (Hebreus 11:1)',
    ),

    // 17. Sabedoria e Decisões
    _ThemeDefinition(
      name: 'Sabedoria e Decisões',
      searchTag: 'sabedoria direcao de deus escolhas',
      keywords: [
        'sabedoria', 'decisao', 'decidir', 'escolha', 'escolher', 'direcao',
        'orientacao', 'discernimento', 'conselho', 'futuro', 'o que fazer',
        'caminho', 'duvidas', 'guiar',
      ],
      chapters: ['Provérbios 3', 'Tiago 1', 'Provérbios 2', 'Salmos 119', 'Salmos 25', 'Provérbios 16', 'Eclesiastes 3', 'Filipenses 1', '1 Reis 3'],
      keyVerse: 'Se algum de vós tem falta de sabedoria, peça-a a Deus, que a todos dá liberalmente. (Tiago 1:5)',
    ),

    // 18. Cansaço e Descanso
    _ThemeDefinition(
      name: 'Cansaço e Descanso',
      searchTag: 'descanso renovo cansaco paz',
      keywords: [
        'cansaco', 'cansado', 'cansada', 'esgotamento', 'burnout', 'exausto',
        'exausta', 'sobrecarregado', 'sobrecarregada', 'fardo', 'peso',
        'descanso', 'descansar', 'renovo', 'renovacao', 'sono',
      ],
      chapters: ['Mateus 11', 'Isaías 40', 'Salmos 23', 'Hebreus 4', 'Salmos 127', 'Êxodo 20', '1 Reis 19', 'Salmos 62'],
      keyVerse: 'Vinde a mim, todos os que estais cansados e oprimidos, e eu vos aliviarei. (Mateus 11:28)',
    ),

    // 19. Libertação e Vitória sobre a Tentação
    _ThemeDefinition(
      name: 'Libertação e Vitória sobre a Tentação',
      searchTag: 'vencer tentacao santidade libertacao',
      keywords: [
        'pecado', 'pecar', 'tentacao', 'tentado', 'fraqueza', 'carne',
        'vicio', 'vicios', 'culpa por pecar', 'arrependimento', 'libertacao',
        'impureza', 'pornografia', 'mentira', 'quedas',
      ],
      chapters: ['1 Coríntios 10', 'Romanos 6', 'Salmos 51', '1 João 1', 'Gálatas 5', 'Tiago 4', 'Romanos 8', 'Salmos 32', '2 Coríntios 7'],
      keyVerse: 'Não veio sobre vós tentação que não fosse humana; mas Deus é fiel e não vos deixará tentar além das vossas forças. (1 Coríntios 10:13)',
    ),

    // 20. Proteção e Batalha Espiritual
    _ThemeDefinition(
      name: 'Proteção e Batalha Espiritual',
      searchTag: 'protecao livramento batalha espiritual',
      keywords: [
        'batalha espiritual', 'guerra espiritual', 'armadura de deus', 'protecao',
        'livramento', 'perigo', 'inimigo', 'diabo', 'demonio', 'ciladas',
        'inveja', 'perseguicao', 'refugio', 'socorro',
      ],
      chapters: ['Efésios 6', 'Salmos 91', 'Salmos 121', 'Salmos 27', '2 Coríntios 10', 'Tiago 4', '1 Pedro 5', 'Salmos 34', 'Romanos 8'],
      keyVerse: 'Aquele que habita no esconderijo do Altíssimo, à sombra do Onipotente descansará. (Salmos 91:1)',
    ),

    // 21. Oração e Intimidade com Deus
    _ThemeDefinition(
      name: 'Oração e Intimidade com Deus',
      searchTag: 'oracao intimidade com deus presenca',
      keywords: [
        'oracao', 'orar', 'clamar', 'clamor', 'orando', 'jejum', 'jejuar',
        'devocional', 'intimidade', 'buscar a deus', 'presenca de deus', 'intercessao',
      ],
      chapters: ['Mateus 6', 'Lucas 11', 'Filipenses 4', '1 Tessalonicenses 5', 'Tiago 5', 'Salmos 63', 'Jeremias 33', 'Isaías 58'],
      keyVerse: 'Clama a mim, e responder-te-ei, e anunciar-te-ei coisas grandes e firmes que não sabes. (Jeremias 33:3)',
    ),

    // 22. Gratidão e Adoração
    _ThemeDefinition(
      name: 'Gratidão e Adoração',
      searchTag: 'louvor adoracao gratidao alegria',
      keywords: [
        'gratidao', 'grato', 'grata', 'agradecer', 'obrigado', 'louvor',
        'louvar', 'adoracao', 'adorar', 'alegria', 'alegre', 'regozijo',
        'celebracao', 'bendizer', 'cantar',
      ],
      chapters: ['Salmos 100', 'Salmos 103', 'Salmos 150', 'Filipenses 4', '1 Tessalonicenses 5', 'Salmos 95', 'João 4', 'Salmos 16', 'Neemias 8'],
      keyVerse: 'Em tudo dai graças, porque esta é a vontade de Deus em Cristo Jesus para convosco. (1 Tessalonicenses 5:18)',
    ),

    // 23. Esperança e Recomeço
    _ThemeDefinition(
      name: 'Esperança e Recomeço',
      searchTag: 'recomeco esperanca restauracao novo tempo',
      keywords: [
        'esperanca', 'recomeco', 'recomecar', 'nova historia', 'novo tempo',
        'transformacao', 'mudanca', 'restauracao', 'restituicao', 'novo começo',
      ],
      chapters: ['Lamentações 3', 'Isaías 43', '2 Coríntios 5', 'Romanos 8', 'Filipenses 3', 'Romanos 15', 'Ezequiel 36', 'Jeremias 29'],
      keyVerse: 'As misericórdias do Senhor são a causa de não sermos consumidos; renovam-se a cada manhã. (Lamentações 3:22-23)',
    ),

    // 24. Amizade e Comunhão
    _ThemeDefinition(
      name: 'Amizade e Comunhão',
      searchTag: 'amizade comunhao crista unidade',
      keywords: [
        'amizade', 'amigo', 'amiga', 'amigos', 'companheirismo', 'comunidade',
        'unidade', 'convivio', 'igreja', 'comunhao', 'irmandade',
      ],
      chapters: ['Provérbios 17', 'Provérbios 18', 'João 15', 'Eclesiastes 4', '1 Coríntios 15', '1 Samuel 18', 'Gálatas 6', 'Efésios 4'],
      keyVerse: 'Em todo o tempo ama o amigo e para a hora da angústia nasce o irmão. (Provérbios 17:17)',
    ),

    // 25. Vida Eterna e o Céu
    _ThemeDefinition(
      name: 'Vida Eterna e o Céu',
      searchTag: 'vida eterna esperanca ceu gloria',
      keywords: [
        'vida eterna', 'ceu', 'paraiso', 'eternidade', 'volta de jesus',
        'apocalipse', 'juizo', 'ressurreicao', 'esperanca futura',
      ],
      chapters: ['João 14', '1 Coríntios 15', 'Apocalipse 21', 'Apocalipse 22', 'João 11', '1 Tessalonicenses 4', 'Romanos 8'],
      keyVerse: 'Na casa de meu Pai há muitas moradas... vou preparar-vos lugar. (João 14:2)',
    ),

    // 26. Espírito Santo e Avivamento
    _ThemeDefinition(
      name: 'Espírito Santo e Avivamento',
      searchTag: 'espirito santo avivamento pentecostes dons consolador',
      keywords: [
        'espirito santo', 'avivamento', 'pentecostes', 'dons espirituais',
        'consolador', 'batismo com espirito santo', 'cheio do espirito',
        'aviva', 'avivamento espiritual', 'fogo do espirito', 'avivar',
      ],
      chapters: ['Atos 2', 'João 14', 'João 16', 'Romanos 8', '1 Coríntios 12', 'Gálatas 5', 'Atos 1', 'Efésios 5', 'Ezequiel 37'],
      keyVerse: 'Mas recebereis a virtude do Espírito Santo, que há de vir sobre vós; e ser-me-eis testemunhas. (Atos 1:8)',
    ),

    // 27. Humildade e Mansidão
    _ThemeDefinition(
      name: 'Humildade e Mansidão',
      searchTag: 'humildade mansidao vencer orgulho soberba',
      keywords: [
        'humildade', 'humilde', 'orgulho', 'orgulhoso', 'orgulhosa', 'soberba',
        'arrogancia', 'arrogante', 'vaidade', 'mansidao', 'manso', 'quebrantamento',
        'altivez',
      ],
      chapters: ['Filipenses 2', 'Tiago 4', '1 Pedro 5', 'Provérbios 16', 'Lucas 14', 'Salmos 138', 'Mateus 11', 'Provérbios 11'],
      keyVerse: 'Deus resiste aos soberbos, mas dá graça aos humildes. (Tiago 4:6)',
    ),

    // 28. Propósito e Vocação
    _ThemeDefinition(
      name: 'Propósito e Vocação',
      searchTag: 'proposito vocacao chamado vontade de deus',
      keywords: [
        'proposito', 'chamado', 'vocacao', 'vontade de deus', 'missao',
        'plano de deus', 'para que nasci', 'sentido da vida', 'destino em deus',
      ],
      chapters: ['Jeremias 29', 'Efésios 2', 'Romanos 12', 'Isaías 6', 'Provérbios 19', 'Filipenses 1', 'Salmos 138'],
      keyVerse: 'Porque eu bem sei os pensamentos que penso de vós, diz o Senhor; pensamentos de paz e não de mal. (Jeremias 29:11)',
    ),

    // 29. Integridade e Retidão
    _ThemeDefinition(
      name: 'Integridade e Retidão',
      searchTag: 'integridade justica verdade honestidade',
      keywords: [
        'integridade', 'integro', 'justica', 'justo', 'verdade', 'honestidade',
        'carater', 'retidao', 'sinceridade', 'falsidade',
      ],
      chapters: ['Salmos 15', 'Miqueias 6', 'Salmos 1', 'Provérbios 11', 'Provérbios 21', 'Mateus 5', 'Efésios 4'],
      keyVerse: 'Aquele que anda sinceramente, e pratica a justiça, e fala a verdade no seu coração. (Salmos 15:2)',
    ),
  ];

  static const Map<String, ({String name, String verse, List<String> chapters})> _biblicalFigures = {
    'davi': (
      name: 'Rei Davi',
      verse: 'O Senhor é o meu pastor, nada me faltará. (Salmos 23:1)',
      chapters: ['Salmos 23', '1 Samuel 16', '1 Samuel 17', '2 Samuel 7', 'Salmos 51', 'Salmos 103'],
    ),
    'moises': (
      name: 'Moisés',
      verse: 'O Senhor pelejará por vós, e vós vos calareis. (Êxodo 14:14)',
      chapters: ['Êxodo 3', 'Êxodo 14', 'Êxodo 20', 'Êxodo 33', 'Deuteronômio 34'],
    ),
    'abraao': (
      name: 'Abraão',
      verse: 'Ora, a fé é o firme fundamento das coisas que se esperam. (Hebreus 11:1)',
      chapters: ['Gênesis 12', 'Gênesis 15', 'Gênesis 22', 'Romanos 4', 'Hebreus 11'],
    ),
    'jose': (
      name: 'José do Egito',
      verse: 'Vós bem intentastes mal contra mim; porém Deus o intentou para bem. (Gênesis 50:20)',
      chapters: ['Gênesis 37', 'Gênesis 39', 'Gênesis 41', 'Gênesis 45', 'Gênesis 50'],
    ),
    'elias': (
      name: 'Profeta Elias',
      verse: 'E depois do fogo, uma voz mansa e delicada. (1 Reis 19:12)',
      chapters: ['1 Reis 17', '1 Reis 18', '1 Reis 19', '2 Reis 2'],
    ),
    'daniel': (
      name: 'Profeta Daniel',
      verse: 'O meu Deus enviou o seu anjo, e fechou a boca dos leões. (Daniel 6:22)',
      chapters: ['Daniel 1', 'Daniel 3', 'Daniel 6', 'Daniel 9'],
    ),
    'ester': (
      name: 'Rainha Ester',
      verse: 'E quem sabe se para tal tempo como este chegaste a este reino? (Ester 4:14)',
      chapters: ['Ester 4', 'Ester 5', 'Ester 7', 'Ester 8'],
    ),
    'jo': (
      name: 'Jó',
      verse: 'Eu sei que o meu Redentor vive, e que por fim se levantará sobre a terra. (Jó 19:25)',
      chapters: ['Jó 1', 'Jó 2', 'Jó 19', 'Jó 38', 'Jó 42'],
    ),
    'paulo': (
      name: 'Apóstolo Paulo',
      verse: 'Tudo posso naquele que me fortalece. (Filipenses 4:13)',
      chapters: ['Atos 9', 'Romanos 8', 'Filipenses 3', 'Filipenses 4', '2 Coríntios 12', '2 Timóteo 4'],
    ),
    'pedro': (
      name: 'Apóstolo Pedro',
      verse: 'Tu és o Cristo, o Filho do Deus vivo. (Mateus 16:16)',
      chapters: ['Mateus 16', 'Lucas 22', 'João 21', 'Atos 2', 'Atos 10', '1 Pedro 1', '1 Pedro 5'],
    ),
    'jesus': (
      name: 'Jesus Cristo',
      verse: 'Eu sou o caminho, e a verdade e a vida; ninguém vem ao Pai, senão por mim. (João 14:6)',
      chapters: ['Mateus 5', 'Mateus 6', 'Mateus 7', 'João 1', 'João 14', 'Lucas 15', 'João 3', 'Isaías 53'],
    ),
    'salomao': (
      name: 'Rei Salomão',
      verse: 'O temor do Senhor é o princípio da sabedoria. (Provérbios 9:10)',
      chapters: ['1 Reis 3', 'Provérbios 1', 'Provérbios 3', 'Eclesiastes 3'],
    ),
    'noe': (
      name: 'Noé',
      verse: 'Pela fé Noé, divinamente avisado das coisas que ainda não se viam, preparou a arca. (Hebreus 11:7)',
      chapters: ['Gênesis 6', 'Gênesis 7', 'Gênesis 8', 'Gênesis 9'],
    ),
    'sansao': (
      name: 'Sansão',
      verse: 'Senhor Deus, lembra-te de mim, e esforça-me agora só esta vez. (Juízes 16:28)',
      chapters: ['Juízes 13', 'Juízes 14', 'Juízes 15', 'Juízes 16'],
    ),
    'gideao': (
      name: 'Gideão',
      verse: 'O Senhor é contigo, homem valoroso. (Juízes 6:12)',
      chapters: ['Juízes 6', 'Juízes 7', 'Juízes 8'],
    ),
    'filho prodigo': (
      name: 'O Filho Pródigo',
      verse: 'Porque este meu filho estava morto e reviveu; tinha-se perdido e foi achado. (Lucas 15:24)',
      chapters: ['Lucas 15', 'Romanos 8', 'Salmos 103', '1 João 1'],
    ),
    'bom samaritano': (
      name: 'O Bom Samaritano',
      verse: 'Vai, e faze da mesma maneira. (Lucas 10:37)',
      chapters: ['Lucas 10', '1 Coríntios 13', 'Mateus 22'],
    ),
    'armadura de deus': (
      name: 'A Armadura de Deus',
      verse: 'Revesti-vos de toda a armadura de Deus, para que possais estar firmes. (Efésios 6:11)',
      chapters: ['Efésios 6', 'Salmos 91', '2 Coríntios 10'],
    ),
    'fruto do espirito': (
      name: 'O Fruto do Espírito',
      verse: 'Mas o fruto do Espírito é: amor, gozo, paz, longanimidade, benignidade, bondade, fé. (Gálatas 5:22)',
      chapters: ['Gálatas 5', 'Colossenses 3', '1 Coríntios 13', 'Romanos 8'],
    ),
    'dez mandamentos': (
      name: 'Os Dez Mandamentos',
      verse: 'Amarás o Senhor teu Deus de todo o teu coração, e ao teu próximo como a ti mesmo. (Mateus 22:37-39)',
      chapters: ['Êxodo 20', 'Deuteronômio 5', 'Mateus 22'],
    ),
  };

  static const Set<String> _gospelArtists = {
    'gabriela rocha', 'fernandinho', 'morada', 'diante do trono', 'isaias saad',
    'aline barros', 'anderson freire', 'thalles roberto', 'casa worship',
    'fhop', 'kemuel', 'preto no branco', 'theo rubia', 'gabriel guedes',
    'nivea soares', 'bruna karla', 'cassiane', 'eyshila', 'damares',
    'midian lima', 'paulo cesar baruk', 'alessandro vilas boas', 'ton carfi',
    'clovis pinho', 'laura souguellis', 'juliano son', 'livres para adorar',
    'ministerio zoe', 'eliete bittencourt', 'delino marcal',
  };

  static const Set<String> _preachers = {
    'deive leonardo', 'tiago brunet', 'hernandes dias lopes', 'lucinho barreto',
    'claudio duarte', 'douglas goncalves', 'rodrigo silva', 'talitha pereira',
    'antonio cirilo', 'luciano subira', 'silas malafaia', 'mac anderson',
    'helena tannure', 'junior trovao', 'marcelo oliveira',
  };

  static const List<String> _foundationalChapters = [
    'Salmos 23',
    'Filipenses 4',
    'Provérbios 3',
    'Romanos 8',
    'Mateus 6',
    'Salmos 91',
    'João 14',
    'Isaías 41',
    'Tiago 1',
    'Salmos 121',
    '1 Coríntios 13',
    'Hebreus 11',
  ];

  static String _normalize(String input) {
    const accents = 'áàâãäéèêëíìîïóòôõöúùûüç';
    const plain = 'aaaaaeeeeiiiiooooouuuuc';
    final buffer = StringBuffer();
    for (final c in input.toLowerCase().split('')) {
      final index = accents.indexOf(c);
      buffer.write(index < 0 ? c : plain[index]);
    }
    return buffer
        .toString()
        .replaceAll(RegExp(r'[^a-z0-9 ]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Analisa um texto extenso ou específico e descobre os temas mais relevantes
  List<({_ThemeDefinition theme, double score})> _matchThemes(String normalizedText) {
    final scored = <({_ThemeDefinition theme, double score})>[];

    for (final theme in _themes) {
      double score = 0.0;
      for (final kw in theme.keywords) {
        final kwNorm = _normalize(kw);
        // Frase ou expressão composta (ex: 'perdao a si mesmo', 'amor proprio') tem prioridade máxima
        if (RegExp('(^| )${RegExp.escape(kwNorm)}( |\$)').hasMatch(normalizedText)) {
          final wordCount = kwNorm.split(' ').length;
          score += wordCount >= 3 ? 6.0 : (wordCount == 2 ? 4.0 : 1.5);
        } else if (kwNorm.length >= 5 && normalizedText.contains(kwNorm)) {
          score += 1.0;
        }
      }
      if (score > 0) {
        scored.add((theme: theme, score: score));
      }
    }

    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored;
  }

  static String _extractCoreKeywords(
      String input, List<({_ThemeDefinition theme, double score})> matched) {
    const stopWords = {
      'como', 'para', 'com', 'sem', 'sob', 'sobre', 'pelo', 'pela', 'pelos', 'pelas',
      'de', 'do', 'da', 'dos', 'das', 'no', 'na', 'nos', 'nas', 'em', 'um', 'uma',
      'uns', 'umas', 'que', 'quando', 'onde', 'porque', 'por', 'qual', 'quais',
      'meu', 'minha', 'meus', 'minhas', 'teu', 'tua', 'teus', 'tuas', 'seu', 'sua',
      'seus', 'suas', 'nosso', 'nossa', 'nossos', 'nossas', 'muito', 'muita',
      'mais', 'menos', 'estou', 'estamos', 'estava', 'sinto', 'sentimos',
      'ter', 'fazer', 'estar', 'ser',
    };
    final words = _normalize(input)
        .split(' ')
        .where((w) => w.length > 2 && !stopWords.contains(w))
        .toList();

    if (words.length >= 2 && words.length <= 6) {
      return words.join(' ');
    } else if (words.length > 6) {
      return words.take(5).join(' ');
    }

    if (matched.isNotEmpty) {
      return matched.first.theme.searchTag;
    }
    return input;
  }

  List<String> referencesFor(String title, {List<String> suggested = const []}) {
    final result = <String>[];

    // 1. Verifica se a própria busca é ou contém uma referência bíblica direta
    final directRef = BibleService.normalizeReference(title);
    if (directRef != null) {
      result.add(directRef);
    } else {
      for (final book in BibleService.allBooks) {
        final match = RegExp(
          '(?:\\b)(${RegExp.escape(book.name)}|[1-3]?\\s*${RegExp.escape(book.aliases.first)})\\s+(\\d+)',
          caseSensitive: false,
        ).firstMatch(title);
        if (match != null) {
          final foundRef = BibleService.normalizeReference('${match.group(1)} ${match.group(2)}');
          if (foundRef != null && !result.contains(foundRef)) {
            result.add(foundRef);
          }
        }
      }
    }

    // 2. Se a busca for o nome de um livro bíblico (ex: "Jonas", "Provérbios", "Tiago", "Rute")
    final directBook = BibleService.findBook(title);
    if (directBook != null) {
      final maxCh = min(directBook.chapters, 8);
      for (var i = 1; i <= maxCh; i++) {
        final ref = '${directBook.name} $i';
        if (!result.contains(ref)) result.add(ref);
      }
    }

    // 3. Se a busca for uma figura bíblica famosa ou história bíblica (ex: "Davi", "Moisés", "Filho Pródigo")
    final normalized = _normalize(title);
    for (final entry in _biblicalFigures.entries) {
      if (normalized == entry.key ||
          RegExp('(^| )${RegExp.escape(entry.key)}( |\$)').hasMatch(normalized)) {
        for (final ch in entry.value.chapters) {
          final canonical = BibleService.normalizeReference(ch);
          if (canonical != null && !result.contains(canonical)) {
            result.add(canonical);
          }
        }
      }
    }

    // 4. Análise semântica por temas
    final matched = _matchThemes(normalized);

    // Contabiliza ocorrências de cada capítulo entre os temas identificados para priorizar interseções
    final chapterFrequency = <String, int>{};
    for (final item in matched) {
      for (final ch in item.theme.chapters) {
        chapterFrequency[ch] = (chapterFrequency[ch] ?? 0) + 1;
      }
    }

    final themeChapters = <String>[];
    if (matched.isNotEmpty) {
      // Prioriza capítulos que apareceram em múltiplos temas combinados (ex.: Romanos 8 para perdão a si mesmo + redenção)
      final multiThemeChapters = chapterFrequency.entries
          .where((e) => e.value > 1)
          .toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      for (final entry in multiThemeChapters) {
        final canonical = BibleService.normalizeReference(entry.key);
        if (canonical != null && !themeChapters.contains(canonical)) {
          themeChapters.add(canonical);
        }
      }

      // Adiciona os capítulos dos temas individuais em ordem de relevância
      for (final item in matched) {
        for (final ch in item.theme.chapters) {
          final canonical = BibleService.normalizeReference(ch);
          if (canonical != null && !themeChapters.contains(canonical)) {
            themeChapters.add(canonical);
          }
          if (themeChapters.length >= 14) break;
        }
        if (themeChapters.length >= 14) break;
      }
    }

    for (final ch in themeChapters) {
      if (!result.contains(ch)) result.add(ch);
    }

    // Inclui sugestões pré-existentes se houver
    for (final s in suggested) {
      final canonical = BibleService.normalizeReference(s);
      if (canonical != null && !result.contains(canonical)) {
        result.add(canonical);
      }
    }

    // Se ainda estiver vazio, garante passagens fundamentais
    if (result.isEmpty) {
      for (final ch in _foundationalChapters) {
        final canonical = BibleService.normalizeReference(ch);
        if (canonical != null && !result.contains(canonical)) {
          result.add(canonical);
        }
      }
    }

    return result.take(12).toList(growable: false);
  }

  BibleTopic topicFor(String text) {
    final cleanInput = text.trim();
    final normalized = _normalize(cleanInput);

    // 1. Se for uma referência bíblica direta (ex: "Salmos 23", "João 3:16", "Romanos 8")
    final directRef = BibleService.normalizeReference(cleanInput);
    if (directRef != null) {
      final parsed = BibleService.parseReference(cleanInput);
      final bookName = parsed?.book.name ?? cleanInput;
      final chNum = parsed?.chapter ?? 1;
      return BibleTopic(
        directRef,
        'Leitura do capítulo completo de $bookName $chNum com materiais de estudo.',
        'Explore o texto sagrado versículo por versículo.',
        directRef,
        [directRef],
        detectedKeywords: [bookName, 'Capítulo $chNum'],
        videoSearchTerm: '$directRef estudo bíblico',
        songSearchTerm: '$directRef louvor',
        podcastSearchTerm: '$directRef estudo',
        highlightVerses: [directRef],
      );
    }

    // 2. Se for o nome de um livro bíblico (ex: "Jonas", "Provérbios", "Tiago", "Rute")
    final directBook = BibleService.findBook(cleanInput);
    if (directBook != null) {
      final bookName = directBook.name;
      final maxCh = min(directBook.chapters, 8);
      final bookChapters = [
        for (var i = 1; i <= maxCh; i++) '$bookName $i'
      ];
      final firstRef = '$bookName 1';
      return BibleTopic(
        bookName,
        'Estudo e leitura do livro de $bookName (${directBook.chapters} capítulos).',
        'Toda a Escritura é divinamente inspirada, e proveitosa para ensinar. (2 Timóteo 3:16)',
        firstRef,
        bookChapters,
        detectedKeywords: [bookName, '${directBook.chapters} Capítulos'],
        videoSearchTerm: '$bookName estudo bíblico',
        songSearchTerm: '$bookName louvor',
        podcastSearchTerm: '$bookName estudo bíblico',
        highlightVerses: [firstRef],
      );
    }

    // 3. Se for uma figura bíblica famosa ou história bíblica (ex: "Davi", "Moisés", "Filho Pródigo")
    for (final entry in _biblicalFigures.entries) {
      if (normalized == entry.key ||
          RegExp('(^| )${RegExp.escape(entry.key)}( |\$)').hasMatch(normalized)) {
        final fig = entry.value;
        final references = referencesFor(cleanInput);
        return BibleTopic(
          fig.name,
          'Passagens bíblicas, estudos e reflexões sobre ${fig.name}.',
          fig.verse,
          references.isNotEmpty ? references.first : (fig.chapters.isNotEmpty ? fig.chapters.first : 'Salmos 23'),
          references.isNotEmpty ? references : fig.chapters,
          detectedKeywords: [fig.name, 'História Bíblica'],
          videoSearchTerm: '${fig.name} história bíblica',
          songSearchTerm: '${fig.name} louvor',
          podcastSearchTerm: '${fig.name} reflexão',
          highlightVerses: [fig.verse],
        );
      }
    }

    // 4. Se for um cantor, banda ou artista gospel reconhecido (ex: "Gabriela Rocha", "Morada")
    for (final artist in _gospelArtists) {
      if (normalized == artist || normalized.contains(artist)) {
        final references = referencesFor(cleanInput);
        return BibleTopic(
          cleanInput,
          'Louvores, ministrações e canções edificantes de $cleanInput.',
          'Cantai ao Senhor um cântico novo, cantai ao Senhor toda a terra. (Salmos 96:1)',
          references.isNotEmpty ? references.first : 'Salmos 100',
          references,
          detectedKeywords: ['Música Gospel', 'Adoração', cleanInput],
          videoSearchTerm: cleanInput,
          songSearchTerm: '$cleanInput louvores',
          podcastSearchTerm: cleanInput,
          highlightVerses: ['Salmos 100', 'Salmos 150'],
        );
      }
    }

    // 5. Se for um pregador ou pastor reconhecido (ex: "Deive Leonardo", "Hernandes Dias Lopes")
    for (final preacher in _preachers) {
      if (normalized == preacher || normalized.contains(preacher)) {
        final references = referencesFor(cleanInput);
        return BibleTopic(
          cleanInput,
          'Pregações, estudos e mensagens edificantes de $cleanInput.',
          'Pregai a palavra, insta a tempo e fora de tempo. (2 Timóteo 4:2)',
          references.isNotEmpty ? references.first : 'Romanos 8',
          references,
          detectedKeywords: ['Pregação', 'Estudo da Palavra', cleanInput],
          videoSearchTerm: '$cleanInput pregação',
          songSearchTerm: cleanInput,
          podcastSearchTerm: cleanInput,
          highlightVerses: ['Romanos 8:1', 'Filipenses 4:13'],
        );
      }
    }

    // 6. Análise semântica para temas específicos e extensos
    final matched = _matchThemes(normalized);
    final references = referencesFor(cleanInput);

    if (matched.isNotEmpty) {
      final detectedKeywords = matched.take(4).map((m) => m.theme.name).toList();
      final keyVerse = matched.first.theme.keyVerse;

      // Otimização: o termo colocado pelo usuário é o centro absoluto da pesquisa
      // Se a busca tiver até 7 palavras, usamos o termo exato sem diluir com tags genéricas
      final wordCount = cleanInput.split(RegExp(r'\s+')).length;
      final isConcise = wordCount <= 7;

      final videoQuery = isConcise
          ? '$cleanInput reflexão bíblica'
          : '${_extractCoreKeywords(cleanInput, matched)} reflexão bíblica';

      final songQuery = isConcise
          ? '$cleanInput louvor'
          : '${_extractCoreKeywords(cleanInput, matched)} louvor';

      final podcastQuery = isConcise
          ? cleanInput
          : _extractCoreKeywords(cleanInput, matched);

      final description = detectedKeywords.length == 1
          ? 'Conteúdos bíblicos sobre ${detectedKeywords.first}.'
          : 'Reflexões e passagens para: ${detectedKeywords.join(' • ')}.';

      return BibleTopic(
        cleanInput,
        description,
        keyVerse,
        references.isNotEmpty ? references.first : '',
        references,
        detectedKeywords: detectedKeywords,
        videoSearchTerm: videoQuery,
        songSearchTerm: songQuery,
        podcastSearchTerm: podcastQuery,
        highlightVerses: matched.take(2).map((m) => m.theme.keyVerse).toList(),
      );
    }

    // 7. Fallback inteligente quando nenhum tema foi identificado diretamente:
    // O termo específico do usuário é SEMPRE mantido nas buscas de vídeo, louvor e podcast!
    return BibleTopic(
      cleanInput,
      'Passagens bíblicas de sabedoria e orientação para sua reflexão.',
      'Lâmpada para os meus pés é tua palavra e luz, para o meu caminho. (Salmos 119:105)',
      references.isNotEmpty ? references.first : 'Salmos 23',
      references,
      detectedKeywords: ['Sabedoria', 'Orientação'],
      videoSearchTerm: '$cleanInput reflexão bíblica',
      songSearchTerm: '$cleanInput louvor',
      podcastSearchTerm: cleanInput,
    );
  }
}
