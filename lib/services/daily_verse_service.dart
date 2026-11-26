import '../models/daily_verse_model.dart';

class DailyVerseService {
  const DailyVerseService();

  static const List<DailyVerse> _verses = [
    DailyVerse(
      id: 'dv-1',
      date: null as dynamic,
      reference: 'Filipenses 4:13',
      verseText: 'Tudo posso naquele que me fortalece.',
      theme: 'Força & Vitória',
      reflection: 'Sua capacidade hoje não depende do tamanho dos obstáculos, mas da fonte inesgotável da força de Cristo em você.',
      chapterReference: 'Filipenses 4',
      verseNumber: 13,
    ),
    DailyVerse(
      id: 'dv-2',
      date: null as dynamic,
      reference: 'Jeremias 29:11',
      verseText: 'Porque eu bem sei os pensamentos que penso de vós, diz o Senhor; pensamentos de paz e não de mal, para vos dar o fim que esperais.',
      theme: 'Futuro & Esperança',
      reflection: 'Deus já desenhou o amanhã. Descanse seu coração sabendo que os planos dEle para sua vida transbordam paz e propósito.',
      chapterReference: 'Jeremias 29',
      verseNumber: 11,
    ),
    DailyVerse(
      id: 'dv-3',
      date: null as dynamic,
      reference: 'Salmos 46:1',
      verseText: 'Deus é o nosso refúgio e fortaleza, socorro bem presente na angústia.',
      theme: 'Refúgio & Segurança',
      reflection: 'Mesmo quando a terra treme e as incertezas surgem, o Deus Todo-Poderoso é seu esconderijo inabalável.',
      chapterReference: 'Salmos 46',
      verseNumber: 1,
    ),
    DailyVerse(
      id: 'dv-4',
      date: null as dynamic,
      reference: 'Isaías 40:31',
      verseText: 'Mas os que esperam no Senhor renovarão as suas forças; subirão com asas como águias; correrão e não se cansarão; caminharão e não se fatigarão.',
      theme: 'Renovo & Perseverança',
      reflection: 'Esperar no Senhor não é estagnação, é recarregar as energias espirituais para alçar voos muito mais altos.',
      chapterReference: 'Isaías 40',
      verseNumber: 31,
    ),
    DailyVerse(
      id: 'dv-5',
      date: null as dynamic,
      reference: 'Romanos 8:28',
      verseText: 'E sabemos que todas as coisas cooperam para o bem daqueles que amam a Deus, daqueles que são chamados segundo o seu propósito.',
      theme: 'Soberania Divina',
      reflection: 'Nenhum detalhe da sua história é desperdiçado. Deus transforma até mesmo as adversidades em instrumentos de bênção.',
      chapterReference: 'Romanos 8',
      verseNumber: 28,
    ),
    DailyVerse(
      id: 'dv-6',
      date: null as dynamic,
      reference: 'Josué 1:9',
      verseText: 'Não to mandei eu? Sê forte e corajoso; não temas, nem te espantes, porque o Senhor, teu Deus, é contigo por onde quer que andares.',
      theme: 'Coragem & Fé',
      reflection: 'Dê o próximo passo sem medo. A presença dAquele que governa o universo caminha ao seu lado em cada instante.',
      chapterReference: 'Josué 1',
      verseNumber: 9,
    ),
    DailyVerse(
      id: 'dv-7',
      date: null as dynamic,
      reference: 'Salmos 23:1',
      verseText: 'O Senhor é o meu pastor; nada me faltará.',
      theme: 'Cuidado & Provisão',
      reflection: 'Você tem um Pastor que conhece todas as suas necessidades antes mesmo de você pedir. Confie na providência dEle.',
      chapterReference: 'Salmos 23',
      verseNumber: 1,
    ),
    DailyVerse(
      id: 'dv-8',
      date: null as dynamic,
      reference: 'Provérbios 3:5-6',
      verseText: 'Confia no Senhor de todo o teu coração e não te estribes no teu próprio entendimento. Reconhece-o em todos os teus caminhos, e ele endireitará as tuas veredas.',
      theme: 'Direção & Sabedoria',
      reflection: 'Abra mão de querer controlar cada detalhe. Quando você entrega a direção a Deus, Ele aplana todos os caminhos.',
      chapterReference: 'Provérbios 3',
      verseNumber: 5,
    ),
    DailyVerse(
      id: 'dv-9',
      date: null as dynamic,
      reference: 'Mateus 11:28',
      verseText: 'Vinde a mim, todos os que estais cansados e oprimidos, e eu vos aliviarei.',
      theme: 'Descanso na Alma',
      reflection: 'Deposite suas cargas aos pés de Jesus. O fardo dEle é suave e o descanso que Ele oferece restaura o coração.',
      chapterReference: 'Mateus 11',
      verseNumber: 28,
    ),
    DailyVerse(
      id: 'dv-10',
      date: null as dynamic,
      reference: 'Lamentações 3:22-23',
      verseText: 'As misericórdias do Senhor são a causa de não sermos consumidos, porque as suas misericórdias não têm fim; renovam-se cada manhã; grande é a tua fidelidade.',
      theme: 'Graça & Fidelidade',
      reflection: 'Hoje é um novo começo. A cada nascer do sol, Deus renova o Seu amor e a Sua fidelidade sobre você.',
      chapterReference: 'Lamentações 3',
      verseNumber: 22,
    ),
    DailyVerse(
      id: 'dv-11',
      date: null as dynamic,
      reference: '2 Timóteo 1:7',
      verseText: 'Porque Deus não nos deu o espírito de temor, mas de fortaleza, de amor e de moderação.',
      theme: 'Ousadia & Autodomínio',
      reflection: 'Rejeite a ansiedade e a timidez paralisante. O Espírito que habita em você é de poder divino, compaixão e equilíbrio.',
      chapterReference: '2 Timóteo 1',
      verseNumber: 7,
    ),
    DailyVerse(
      id: 'dv-12',
      date: null as dynamic,
      reference: 'Salmos 121:1-2',
      verseText: 'Levantarei os meus olhos para os montes: de onde me virá o socorro? O meu socorro vem do Senhor, que fez o céu e a terra.',
      theme: 'Socorro dos Céus',
      reflection: 'Não olhe para a magnitude dos problemas; eleve os olhos para o Criador dos céus e da terra. O seu socorro não falha.',
      chapterReference: 'Salmos 121',
      verseNumber: 1,
    ),
  ];

  static DailyVerse getVerseForDate(DateTime date) {
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    final index = dayOfYear.abs() % _verses.length;
    final template = _verses[index];

    return DailyVerse(
      id: 'dv-${date.year}-${date.month}-${date.day}',
      date: date,
      reference: template.reference,
      verseText: template.verseText,
      theme: template.theme,
      reflection: template.reflection,
      chapterReference: template.chapterReference,
      verseNumber: template.verseNumber,
    );
  }

  static DailyVerse getTodayVerse() {
    return getVerseForDate(DateTime.now());
  }
}
