import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bible_model.dart';

export '../models/bible_model.dart';

class BibleService {
  BibleService({this.client});
  final http.Client? client;

  static final Map<String, BibleChapter> _memoryCache = {};

  static int get cachedChapterCount => _memoryCache.length;
  static void clearCache() => _memoryCache.clear();

  static const Map<String, String> translationTitles = {
    'ACF11': 'Almeida Corrigida Fiel (ACF)',
    'ARA': 'Almeida Revista e Atualizada (ARA)',
    'ARC09': 'Almeida Revista e Corrigida (ARC)',
    'NVIPT': 'Nova Versão Internacional (NVI)',
    'RV1960': 'Reina Valera 1960 (RVR1960)',
    'WEB': 'World English Bible (WEB)',
  };

  static const List<BibleBookInfo> allBooks = [
    BibleBookInfo(id: 1, name: 'Gênesis', chapters: 50, englishSlug: 'genesis', aliases: ['genesis', 'gn', 'gen']),
    BibleBookInfo(id: 2, name: 'Êxodo', chapters: 40, englishSlug: 'exodus', aliases: ['exodo', 'ex', 'êx']),
    BibleBookInfo(id: 3, name: 'Levítico', chapters: 27, englishSlug: 'leviticus', aliases: ['levitico', 'lv', 'lev']),
    BibleBookInfo(id: 4, name: 'Números', chapters: 36, englishSlug: 'numbers', aliases: ['numeros', 'nm', 'num']),
    BibleBookInfo(id: 5, name: 'Deuteronômio', chapters: 34, englishSlug: 'deuteronomy', aliases: ['deuteronomio', 'dt', 'deu']),
    BibleBookInfo(id: 6, name: 'Josué', chapters: 24, englishSlug: 'joshua', aliases: ['josue', 'js', 'jos']),
    BibleBookInfo(id: 7, name: 'Juízes', chapters: 21, englishSlug: 'judges', aliases: ['juizes', 'jz', 'jui']),
    BibleBookInfo(id: 8, name: 'Rute', chapters: 4, englishSlug: 'ruth', aliases: ['rt', 'rut']),
    BibleBookInfo(id: 9, name: '1 Samuel', chapters: 31, englishSlug: '1 samuel', aliases: ['1samuel', '1 sam', '1sm', '1s']),
    BibleBookInfo(id: 10, name: '2 Samuel', chapters: 24, englishSlug: '2 samuel', aliases: ['2samuel', '2 sam', '2sm', '2s']),
    BibleBookInfo(id: 11, name: '1 Reis', chapters: 22, englishSlug: '1 kings', aliases: ['1reis', '1 re', '1rs', '1r']),
    BibleBookInfo(id: 12, name: '2 Reis', chapters: 25, englishSlug: '2 kings', aliases: ['2reis', '2 re', '2rs', '2r']),
    BibleBookInfo(id: 13, name: '1 Crônicas', chapters: 29, englishSlug: '1 chronicles', aliases: ['1cronicas', '1 cr', '1cron']),
    BibleBookInfo(id: 14, name: '2 Crônicas', chapters: 36, englishSlug: '2 chronicles', aliases: ['2cronicas', '2 cr', '2cron']),
    BibleBookInfo(id: 15, name: 'Esdras', chapters: 10, englishSlug: 'ezra', aliases: ['ed', 'esd']),
    BibleBookInfo(id: 16, name: 'Neemias', chapters: 13, englishSlug: 'nehemiah', aliases: ['ne', 'nee']),
    BibleBookInfo(id: 17, name: 'Ester', chapters: 10, englishSlug: 'esther', aliases: ['et', 'est']),
    BibleBookInfo(id: 18, name: 'Jó', chapters: 42, englishSlug: 'job', aliases: ['jo', 'jb']),
    BibleBookInfo(id: 19, name: 'Salmos', chapters: 150, englishSlug: 'psalms', aliases: ['salmo', 'sl', 'psm', 'psalmo', 'psalmos']),
    BibleBookInfo(id: 20, name: 'Provérbios', chapters: 31, englishSlug: 'proverbs', aliases: ['proverbios', 'pv', 'prv']),
    BibleBookInfo(id: 21, name: 'Eclesiastes', chapters: 12, englishSlug: 'ecclesiastes', aliases: ['ec', 'ecl']),
    BibleBookInfo(id: 22, name: 'Cânticos', chapters: 8, englishSlug: 'song of solomon', aliases: ['canticos', 'cantares', 'cântico dos cânticos', 'cantico dos canticos', 'ct', 'cnt']),
    BibleBookInfo(id: 23, name: 'Isaías', chapters: 66, englishSlug: 'isaiah', aliases: ['isaias', 'is', 'isa']),
    BibleBookInfo(id: 24, name: 'Jeremias', chapters: 52, englishSlug: 'jeremiah', aliases: ['jr', 'jer']),
    BibleBookInfo(id: 25, name: 'Lamentações', chapters: 5, englishSlug: 'lamentations', aliases: ['lamentacoes', 'lm', 'lam']),
    BibleBookInfo(id: 26, name: 'Ezequiel', chapters: 48, englishSlug: 'ezekiel', aliases: ['ez', 'eze']),
    BibleBookInfo(id: 27, name: 'Daniel', chapters: 12, englishSlug: 'daniel', aliases: ['dn', 'dan']),
    BibleBookInfo(id: 28, name: 'Oseias', chapters: 14, englishSlug: 'hosea', aliases: ['os', 'hos']),
    BibleBookInfo(id: 29, name: 'Joel', chapters: 3, englishSlug: 'joel', aliases: ['jl', 'joe']),
    BibleBookInfo(id: 30, name: 'Amós', chapters: 9, englishSlug: 'amos', aliases: ['amos', 'am', 'ams']),
    BibleBookInfo(id: 31, name: 'Obadias', chapters: 1, englishSlug: 'obadiah', aliases: ['ob', 'oba']),
    BibleBookInfo(id: 32, name: 'Jonas', chapters: 4, englishSlug: 'jonah', aliases: ['jn', 'jon']),
    BibleBookInfo(id: 33, name: 'Miqueias', chapters: 7, englishSlug: 'micah', aliases: ['miqueias', 'mq', 'miq']),
    BibleBookInfo(id: 34, name: 'Naum', chapters: 3, englishSlug: 'nahum', aliases: ['na', 'nam']),
    BibleBookInfo(id: 35, name: 'Habacuque', chapters: 3, englishSlug: 'habakkuk', aliases: ['hc', 'hab']),
    BibleBookInfo(id: 36, name: 'Sofonias', chapters: 3, englishSlug: 'zephaniah', aliases: ['sf', 'sof']),
    BibleBookInfo(id: 37, name: 'Ageu', chapters: 2, englishSlug: 'haggai', aliases: ['ag', 'age']),
    BibleBookInfo(id: 38, name: 'Zacarias', chapters: 14, englishSlug: 'zechariah', aliases: ['zc', 'zac']),
    BibleBookInfo(id: 39, name: 'Malaquias', chapters: 4, englishSlug: 'malachi', aliases: ['ml', 'mal']),
    BibleBookInfo(id: 40, name: 'Mateus', chapters: 28, englishSlug: 'matthew', aliases: ['mt', 'mat']),
    BibleBookInfo(id: 41, name: 'Marcos', chapters: 16, englishSlug: 'mark', aliases: ['mc', 'mar']),
    BibleBookInfo(id: 42, name: 'Lucas', chapters: 24, englishSlug: 'luke', aliases: ['lc', 'luc']),
    BibleBookInfo(id: 43, name: 'João', chapters: 21, englishSlug: 'john', aliases: ['joao', 'jo', 'jhn']),
    BibleBookInfo(id: 44, name: 'Atos', chapters: 28, englishSlug: 'acts', aliases: ['at', 'act']),
    BibleBookInfo(id: 45, name: 'Romanos', chapters: 16, englishSlug: 'romans', aliases: ['rm', 'rom']),
    BibleBookInfo(id: 46, name: '1 Coríntios', chapters: 16, englishSlug: '1 corinthians', aliases: ['1corintios', '1 cor', '1co', '1c']),
    BibleBookInfo(id: 47, name: '2 Coríntios', chapters: 13, englishSlug: '2 corinthians', aliases: ['2corintios', '2 cor', '2co', '2c']),
    BibleBookInfo(id: 48, name: 'Gálatas', chapters: 6, englishSlug: 'galatians', aliases: ['galatas', 'gl', 'gal']),
    BibleBookInfo(id: 49, name: 'Efésios', chapters: 6, englishSlug: 'ephesians', aliases: ['efesios', 'ef', 'eph']),
    BibleBookInfo(id: 50, name: 'Filipenses', chapters: 4, englishSlug: 'philippians', aliases: ['fp', 'fl', 'php', 'phil']),
    BibleBookInfo(id: 51, name: 'Colossenses', chapters: 4, englishSlug: 'colossians', aliases: ['cl', 'col']),
    BibleBookInfo(id: 52, name: '1 Tessalonicenses', chapters: 5, englishSlug: '1 thessalonians', aliases: ['1tessalonicenses', '1 tes', '1ts', '1t']),
    BibleBookInfo(id: 53, name: '2 Tessalonicenses', chapters: 3, englishSlug: '2 thessalonians', aliases: ['2tessalonicenses', '2 tes', '2ts', '2t']),
    BibleBookInfo(id: 54, name: '1 Timóteo', chapters: 6, englishSlug: '1 timothy', aliases: ['1timoteo', '1 tim', '1tm']),
    BibleBookInfo(id: 55, name: '2 Timóteo', chapters: 4, englishSlug: '2 timothy', aliases: ['2timoteo', '2 tim', '2tm']),
    BibleBookInfo(id: 56, name: 'Tito', chapters: 3, englishSlug: 'titus', aliases: ['tt', 'tit']),
    BibleBookInfo(id: 57, name: 'Filemom', chapters: 1, englishSlug: 'philemon', aliases: ['fm', 'flm', 'phm']),
    BibleBookInfo(id: 58, name: 'Hebreus', chapters: 13, englishSlug: 'hebrews', aliases: ['hb', 'heb']),
    BibleBookInfo(id: 59, name: 'Tiago', chapters: 5, englishSlug: 'james', aliases: ['tg', 'jas']),
    BibleBookInfo(id: 60, name: '1 Pedro', chapters: 5, englishSlug: '1 peter', aliases: ['1pedro', '1 ped', '1pe', '1p']),
    BibleBookInfo(id: 61, name: '2 Pedro', chapters: 3, englishSlug: '2 peter', aliases: ['2pedro', '2 ped', '2pe', '2p']),
    BibleBookInfo(id: 62, name: '1 João', chapters: 5, englishSlug: '1 john', aliases: ['1joao', '1 jo', '1jhn', '1j']),
    BibleBookInfo(id: 63, name: '2 João', chapters: 1, englishSlug: '2 john', aliases: ['2joao', '2 jo', '2jhn', '2j']),
    BibleBookInfo(id: 64, name: '3 João', chapters: 1, englishSlug: '3 john', aliases: ['3joao', '3 jo', '3jhn', '3j']),
    BibleBookInfo(id: 65, name: 'Judas', chapters: 1, englishSlug: 'jude', aliases: ['jd', 'jud']),
    BibleBookInfo(id: 66, name: 'Apocalipse', chapters: 22, englishSlug: 'revelation', aliases: ['ap', 'apoc', 'rev']),
  ];

  static String _cleanText(String input) {
    const accents = 'áàâãäéèêëíìîïóòôõöúùûüç';
    const plain = 'aaaaaeeeeiiiiooooouuuuc';
    final buffer = StringBuffer();
    for (final c in input.toLowerCase().split('')) {
      final index = accents.indexOf(c);
      buffer.write(index < 0 ? c : plain[index]);
    }
    return buffer
        .toString()
        .replaceAll(RegExp(r'[^a-z0-9]'), '')
        .trim();
  }

  static BibleBookInfo? findBook(String query) {
    final cleaned = _cleanText(query);
    if (cleaned.isEmpty) return null;

    for (final book in allBooks) {
      if (_cleanText(book.name) == cleaned) return book;
      for (final alias in book.aliases) {
        if (_cleanText(alias) == cleaned) return book;
      }
    }
    return null;
  }

  static ({BibleBookInfo book, int chapter, int? verse})? parseReference(String input) {
    final trimmed = input.trim();
    // Matches patterns like "Salmos 23", "Sl 23:1", "1 João 4:8", "Gênesis 1", "João 3:16-17"
    final regex = RegExp(
      r'^(?:livro de\s+|o livro de\s+)?([1-3]?\s*[A-Za-zÀ-ÿ]+(?:\s+dos\s+[A-Za-zÀ-ÿ]+|\s+de\s+[A-Za-zÀ-ÿ]+)?)\s+(\d+)(?:[:,\.](\d+)(?:[-–]\d+)?)?$',
      caseSensitive: false,
    );
    final match = regex.firstMatch(trimmed);
    if (match == null) return null;

    final rawBook = match.group(1)!.trim();
    final book = findBook(rawBook);
    if (book == null) return null;

    final chapter = int.tryParse(match.group(2)!);
    if (chapter == null || chapter < 1 || chapter > book.chapters) return null;

    final verse = match.group(3) != null ? int.tryParse(match.group(3)!) : null;

    return (book: book, chapter: chapter, verse: verse);
  }

  static String? normalizeReference(String input) {
    final parsed = parseReference(input);
    if (parsed == null) return null;
    return '${parsed.book.name} ${parsed.chapter}';
  }

  static String? previousChapter(String reference) {
    final parsed = parseReference(reference);
    if (parsed == null) return null;
    if (parsed.chapter > 1) {
      return '${parsed.book.name} ${parsed.chapter - 1}';
    }
    // Previous book's last chapter
    if (parsed.book.id > 1) {
      final prevBook = allBooks[parsed.book.id - 2];
      return '${prevBook.name} ${prevBook.chapters}';
    }
    return null;
  }

  static String? nextChapter(String reference) {
    final parsed = parseReference(reference);
    if (parsed == null) return null;
    if (parsed.chapter < parsed.book.chapters) {
      return '${parsed.book.name} ${parsed.chapter + 1}';
    }
    // Next book's first chapter
    if (parsed.book.id < allBooks.length) {
      final nextBook = allBooks[parsed.book.id];
      return '${nextBook.name} 1';
    }
    return null;
  }

  static String _stripHtml(String text) {
    return text
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  Future<BibleChapter> chapter(String reference, {String? preferredTranslation}) async {
    final parsed = parseReference(reference);
    if (parsed == null) {
      throw const FormatException('Referência bíblica inválida ou não reconhecida.');
    }

    final trans = preferredTranslation ?? 'ACF11';
    final cacheKey = '${parsed.book.id}:${parsed.chapter}:$trans';
    if (_memoryCache.containsKey(cacheKey)) {
      return _memoryCache[cacheKey]!;
    }

    final httpClient = client ?? http.Client();
    try {
      // 1. Tenta a tradução preferida do usuário
      final preferredTitle = translationTitles[trans] ?? trans;
      if (trans == 'WEB') {
        try {
          final webResult = await _fetchBibleApiWeb(httpClient, parsed.book, parsed.chapter);
          if (webResult != null && webResult.verses.isNotEmpty) {
            _memoryCache[cacheKey] = webResult;
            return webResult;
          }
        } catch (_) {}
      } else {
        try {
          final prefResult = await _fetchBolls(httpClient, trans, parsed.book, parsed.chapter, preferredTitle);
          if (prefResult != null && prefResult.verses.isNotEmpty) {
            _memoryCache[cacheKey] = prefResult;
            return prefResult;
          }
        } catch (_) {}
      }

      // 2. Fallbacks em português
      final fallbacks = ['ACF11', 'ARA', 'ARC09'].where((slug) => slug != trans);
      for (final fallbackSlug in fallbacks) {
        try {
          final title = translationTitles[fallbackSlug] ?? fallbackSlug;
          final res = await _fetchBolls(httpClient, fallbackSlug, parsed.book, parsed.chapter, title);
          if (res != null && res.verses.isNotEmpty) {
            _memoryCache[cacheKey] = res;
            return res;
          }
        } catch (_) {}
      }

      // 3. Fallback final: bible-api.com (WEB)
      try {
        final webResult = await _fetchBibleApiWeb(httpClient, parsed.book, parsed.chapter);
        if (webResult != null && webResult.verses.isNotEmpty) {
          _memoryCache[cacheKey] = webResult;
          return webResult;
        }
      } catch (_) {}

      throw Exception('Não foi possível carregar o capítulo no momento. Verifique sua conexão à internet e tente novamente.');
    } finally {
      if (client == null) httpClient.close();
    }
  }

  Future<BibleChapter?> _fetchBolls(
    http.Client httpClient,
    String translationSlug,
    BibleBookInfo book,
    int chapter,
    String translationTitle,
  ) async {
    final uri = Uri.https('bolls.life', '/get-text/$translationSlug/${book.id}/$chapter/');
    final response = await httpClient.get(uri).timeout(const Duration(seconds: 12));

    if (response.statusCode != 200) return null;
    final raw = jsonDecode(utf8.decode(response.bodyBytes));
    if (raw is! List || raw.isEmpty) return null;

    final verses = <BibleVerse>[];
    for (final item in raw.whereType<Map>()) {
      final verseNum = (item['verse'] as num?)?.toInt();
      final text = item['text'] as String?;
      if (verseNum != null && text != null && text.isNotEmpty) {
        verses.add(BibleVerse(verseNum, _stripHtml(text)));
      }
    }

    if (verses.isEmpty) return null;

    return BibleChapter(
      '${book.name} $chapter',
      translationTitle,
      verses,
      bookName: book.name,
      chapterNumber: chapter,
      totalChapters: book.chapters,
    );
  }

  Future<BibleChapter?> _fetchBibleApiWeb(
    http.Client httpClient,
    BibleBookInfo book,
    int chapter,
  ) async {
    final uri = Uri.https('bible-api.com', '/${book.englishSlug}+$chapter');
    final response = await httpClient.get(uri).timeout(const Duration(seconds: 12));

    if (response.statusCode != 200) return null;
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    if (data is! Map || data['verses'] is! List) return null;

    final verses = <BibleVerse>[];
    for (final v in (data['verses'] as List).whereType<Map>()) {
      final numVal = (v['verse'] as num?)?.toInt();
      final text = v['text'] as String?;
      if (numVal != null && text != null) {
        verses.add(BibleVerse(numVal, _stripHtml(text)));
      }
    }

    if (verses.isEmpty) return null;

    return BibleChapter(
      '${book.name} $chapter',
      'World English Bible (WEB)',
      verses,
      bookName: book.name,
      chapterNumber: chapter,
      totalChapters: book.chapters,
    );
  }
}
