import 'package:flutter/material.dart';

import '../../controllers/settings_controller.dart';
import '../../models/bible_model.dart';
import '../../services/app_localizations.dart';
import '../../services/bible_service.dart';
import '../../widgets/tv_focusable.dart';
import '../chapter/chapter_view.dart';

class BibleView extends StatefulWidget {
  const BibleView({super.key});

  @override
  State<BibleView> createState() => _BibleViewState();
}

class _BibleViewState extends State<BibleView> {
  final _searchController = TextEditingController();
  final _settings = SettingsController.instance;

  String _searchQuery = '';
  int _selectedTestament = 0; // 0: Todos, 1: Antigo Testamento, 2: Novo Testamento

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value.trim();
    });
  }

  void _openChapter(String reference) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChapterView(
          reference: reference,
          preferredTranslation: _settings.bibleTranslation,
        ),
      ),
    );
  }

  void _showChapterPicker(BibleBookInfo book) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.65,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.outlineVariant.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colors.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.menu_book_rounded,
                          color: colors.onPrimaryContainer,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.name,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${book.chapters} capítulos • ${book.id <= 39 ? "Antigo Testamento" : "Novo Testamento"}',
                              style: TextStyle(color: colors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 70,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: book.chapters,
                      itemBuilder: (context, index) {
                        final chapterNum = index + 1;
                        final ref = '${book.name} $chapterNum';

                        return TvFocusable(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            _openChapter(ref);
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(ctx).pop();
                              _openChapter(ref);
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: colors.surfaceContainerHighest.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: colors.outlineVariant.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                '$chapterNum',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<BibleBookInfo> _getFilteredBooks() {
    var books = BibleService.allBooks;

    if (_selectedTestament == 1) {
      books = books.where((b) => b.id <= 39).toList();
    } else if (_selectedTestament == 2) {
      books = books.where((b) => b.id > 39).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      books = books.where((b) {
        if (b.name.toLowerCase().contains(q)) return true;
        for (final alias in b.aliases) {
          if (alias.toLowerCase().contains(q)) return true;
        }
        return false;
      }).toList();
    }

    return books;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final strings = AppLocalizations.of(_settings.language);

    final filteredBooks = _getFilteredBooks();
    final parsedDirectRef = _searchQuery.isNotEmpty
        ? BibleService.parseReference(_searchQuery)
        : null;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      children: [
        // Hero Banner da Bíblia Sagrada
        Card(
          elevation: _settings.highContrast ? 2 : 1,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1B3B36),
                  Color(0xFF0F2622),
                ],
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4CA83),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.auto_stories_rounded,
                        color: Color(0xFF1E301F),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'PALAVRA DE DEUS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFF4CA83),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '66 Livros',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Bíblia Sagrada',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Leia, pesquise e medite em qualquer um dos 66 livros bíblicos e seus capítulos completos.',
                  style: TextStyle(
                    color: Color(0xFFDBEEE6),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                TvFocusable(
                  onPressed: () => _openChapter('Salmos 23'),
                  borderRadius: BorderRadius.circular(14),
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFF4CA83),
                      foregroundColor: const Color(0xFF1E301F),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () => _openChapter('Salmos 23'),
                    icon: const Icon(Icons.menu_book_rounded, size: 20),
                    label: const Text(
                      'Leitura em Destaque: Salmos 23',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Campo de Pesquisa de Trecho ou Livro
        TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          onSubmitted: (value) {
            if (parsedDirectRef != null) {
              _openChapter('${parsedDirectRef.book.name} ${parsedDirectRef.chapter}');
            }
          },
          decoration: InputDecoration(
            hintText: 'Pesquise um livro, capítulo ou trecho (ex.: Salmos 23, João 3:16)...',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  )
                : null,
            filled: true,
            fillColor: colors.surfaceContainer,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          ),
        ),
        const SizedBox(height: 14),

        // Atalho direto quando a referência foi identificada
        if (parsedDirectRef != null) ...[
          Card(
            margin: EdgeInsets.zero,
            color: colors.primaryContainer.withValues(alpha: 0.45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: colors.primary.withValues(alpha: 0.3)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.auto_stories_rounded, color: colors.onPrimary, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Passagem reconhecida:',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${parsedDirectRef.book.name} ${parsedDirectRef.chapter}${parsedDirectRef.verse != null ? ":${parsedDirectRef.verse}" : ""}',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => _openChapter('${parsedDirectRef.book.name} ${parsedDirectRef.chapter}'),
                    icon: const Icon(Icons.menu_book_rounded, size: 16),
                    label: const Text('Ler Agora'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Trechos Populares Recomendados
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Text('Trechos rápidos:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              _popularChip('Salmos 23'),
              _popularChip('Salmos 91'),
              _popularChip('João 3'),
              _popularChip('Romanos 8'),
              _popularChip('1 Coríntios 13'),
              _popularChip('Mateus 5'),
              _popularChip('Isaías 53'),
              _popularChip('Filipenses 4'),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Filtro de Testamento
        Row(
          children: [
            _testamentChip('Todos (66)', 0),
            const SizedBox(width: 8),
            _testamentChip('Antigo (39)', 1),
            const SizedBox(width: 8),
            _testamentChip('Novo (27)', 2),
          ],
        ),
        const SizedBox(height: 16),

        // Grade de Livros
        if (filteredBooks.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const Icon(Icons.search_off_rounded, size: 40),
                  const SizedBox(height: 12),
                  Text(
                    'Nenhum livro ou passagem encontrado para "$_searchQuery".',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  FilledButton.tonal(
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                    child: const Text('Limpar busca e ver todos os livros'),
                  ),
                ],
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 260,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.2,
            ),
            itemCount: filteredBooks.length,
            itemBuilder: (context, index) {
              final book = filteredBooks[index];
              final isOld = book.id <= 39;

              return TvFocusable(
                onPressed: () => _showChapterPicker(book),
                borderRadius: BorderRadius.circular(16),
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: colors.outlineVariant.withValues(alpha: 0.25),
                    ),
                  ),
                  child: InkWell(
                    onTap: () => _showChapterPicker(book),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isOld
                                  ? colors.secondaryContainer.withValues(alpha: 0.7)
                                  : colors.primaryContainer.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${book.id}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: isOld
                                    ? colors.onSecondaryContainer
                                    : colors.onPrimaryContainer,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  book.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${book.chapters} cap. • ${isOld ? "AT" : "NT"}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 18,
                            color: colors.onSurfaceVariant.withValues(alpha: 0.6),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _popularChip(String ref) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: TvFocusable(
        onPressed: () => _openChapter(ref),
        borderRadius: BorderRadius.circular(16),
        child: ActionChip(
          label: Text(ref, style: const TextStyle(fontSize: 12)),
          onPressed: () => _openChapter(ref),
        ),
      ),
    );
  }

  Widget _testamentChip(String label, int value) {
    final isSelected = _selectedTestament == value;
    return TvFocusable(
      onPressed: () => setState(() => _selectedTestament = value),
      borderRadius: BorderRadius.circular(20),
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 13)),
        selected: isSelected,
        onSelected: (_) => setState(() => _selectedTestament = value),
      ),
    );
  }
}
