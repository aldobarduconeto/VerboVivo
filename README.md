# VerboVivo 📖✨

> **Plataforma multiplataforma moderna e clean para reflexão bíblica, leitura das escrituras, cinema cristão, estudos e podcasts edificantes.**

O **VerboVivo** é um aplicativo de última geração construído em **Flutter** e arquitetado sob o padrão **MVC (Model-View-Controller)**. Ele conecta pessoas à Palavra de Deus e a produções audiovisuais relevantes por meio de uma experiência visual moderna, limpa e responsiva, projetada com foco em alta performance, acessibilidade e suporte completo a Smart TVs e gamepads.

---

## 📑 Sumário

- [Visão Geral e Diferenciais](#-visão-geral-e-diferenciais)
- [Design System & Interface Clean](#-design-system--interface-clean)
- [Arquitetura do Projeto (MVC)](#-arquitetura-do-projeto-mvc)
- [Módulos e Funcionalidades](#-módulos-e-funcionalidades)
  - [1. Estudo Bíblico & Motor Semântico de Tópicos](#1-estudo-bíblico--motor-semântico-de-tópicos)
  - [2. Aba Bíblia Sagrada & Leitor de Passagens](#2-aba-bíblia-sagrada--leitor-de-passagens)
  - [3. Cinema & Séries Angel Studios (`angel.com/pt-BR`)](#3-cinema--séries-angel-studios-angelcompt-br)
  - [4. Streaming de Vídeos Otimizado (100% no Aplicativo)](#4-streaming-de-vídeos-otimizado-100-no-aplicativo)
  - [5. Podcasts Cristãos Integrados](#5-podcasts-cristãos-integrados)
  - [6. Modo TV & Controle Remoto / Gamepads (Interface 10 Pés)](#6-modo-tv--controle-remoto--gamepads-interface-10-pés)
  - [7. Central de Configurações e Acessibilidade](#7-central-de-configurações-e-acessibilidade)
- [Otimizações de Desempenho e Caching](#-otimizações-de-desempenho-e-caching)
- [Tecnologias e Dependências](#-tecnologias-e-dependências)
- [Como Executar e Compilar](#-como-executar-e-compilar)
- [Suíte de Testes e Qualidade](#-suíte-de-testes-e-qualidade)
- [Fontes de Dados e Créditos](#-fontes-de-dados-e-créditos)
- [Licença](#-licença)

---

## 🌟 Visão Geral e Diferenciais

* **Compreensão Semântica de Temas Extensos:** Interpreta frases e situações do cotidiano (ex.: *"como vencer o medo e a angústia no trabalho"* ou *"perdão a si mesmo e amor próprio"*), extraindo eixos temáticos precisos e passagens bíblicas relevantes.
* **Aba Dedicada à Bíblia Sagrada:** Acesso direto a todos os 66 livros da Bíblia com contagem de capítulos, separação por testamentos (Antigo 39, Novo 27), reconhecimento imediato de passagens pesquisadas e seletor modal em grade.
* **Cinema Angel Studios 100% Gratuito:** Hub dedicado às produções de fé e valores familiares de `angel.com/pt-BR` (*The Chosen*, *O Jovem Davi*, *Bonhoeffer*, *Cabrini*, *Dry Bar Comedy*), sem exigência de login ou redirecionamentos externos.
* **Reprodução Forçada no App com Performance Instantânea:** Resolução em corrida concorrente paralela (*Fast Racing*), pré-aquecimento de streams em segundo plano (*Preload*) e cache em memória (início em **0 ms**).
* **Navegação Adaptativa Fluida:** Suporte completo para telas pequenas (smartphones), médias (tablets), grandes (desktops) e de 10 pés (Smart TVs com Android TV / Fire TV).
* **Acessibilidade Inclusiva:** Modo de **Alto Contraste**, personalização cromática, ajuste dinâmico do tamanho das fontes e suporte multilíngue (**Português**, **Inglês** e **Espanhol**).

---

## 🎨 Design System & Interface Clean

O aplicativo adota uma identidade visual moderna e minimalista, alinhada aos princípios contemporâneos do **Material 3**:

* **Superfícies e Tons Profundos:**
  * **Modo Escuro:** Paleta em grafite/ardósia escuro (`#0C1014` de fundo e `#141A22` nos cards), eliminando o contraste artificial de fundos pretos chapados e reduzindo a fadiga visual.
  * **Modo Claro:** Fundo suave e acolhedor (`#F7F9FC` com cards brancos `#FFFFFF`), promovendo clareza e legibilidade.
* **Geometria Suave e Bordas Tonais:** Cantos generosamente arredondados (raio de 22 a 28px) combinados a bordas ultra-finas e translúcidas (12% a 25% de opacidade).
* **Header Moderno:** Emblema com gradiente dinâmico, sombra suave e botões de ação em pílulas tonais (`IconButton.filledTonal`).
* **Floating Bottom Dock no Leitor:** Barra inferior flutuante com cantos arredondados e sombra suave para transição contínua entre capítulos.
* **Cards com Vinheta e Botão Frosted Glass:** Miniaturas 16:9 com gradiente suave na base e botão de reprodução estilizado em vidro fosco com anel dourado.

---

## 🏗 Arquitetura do Projeto (MVC)

O código é estritamente desacoplado segundo o padrão **MVC (Model-View-Controller)**:

```text
VerboVivo/
├── android/                  # Manifestos nativos Android e suporte Leanback TV
├── ios/                      # Configurações nativas iOS
├── windows/                  # Runner nativo Windows (C++)
├── macos/                    # Runner nativo macOS
├── linux/                    # Runner nativo Linux (GTK / libmpv)
├── lib/
│   ├── main.dart             # Ponto de entrada, inicialização precoce do MediaKit e temas
│   │
│   ├── models/               # [MODEL] Entidades e estruturas de dados do domínio
│   │   ├── angel_model.dart          # AngelMediaItem (The Chosen, Davi, Filmes, Séries)
│   │   ├── bible_model.dart          # BibleChapter, BibleVerse, BibleBookInfo
│   │   ├── media_model.dart          # VideoItem, PodcastItem, ResolvedVideo, SearchUnavailable
│   │   ├── settings_model.dart       # AccentColorOption, AppSettings (Modo TV, Contraste)
│   │   ├── topic_model.dart          # BibleTopic, TopicGenerator, catálogo de tópicos
│   │   └── topic.dart                # Exportador retrocompatível
│   │
│   ├── controllers/          # [CONTROLLER] Gerenciamento de estado e regras de negócio
│   │   ├── home_controller.dart      # Orquestração das 4 abas, busca e catálogo Angel
│   │   ├── chapter_controller.dart   # Leitura bíblica, fontes, navegação entre capítulos
│   │   ├── podcast_controller.dart   # Controle de reprodução e eventos de áudio do podcast
│   │   └── settings_controller.dart  # Persistência reativa (tema, cor, contraste, idioma, Modo TV)
│   │
│   ├── views/                # [VIEW] Telas desacopladas e interfaces de usuário
│   │   ├── home/
│   │   │   ├── home_view.dart        # Shell responsivo adaptativo (4 abas)
│   │   │   └── widgets/
│   │   │       ├── angel_card.dart            # Card cinematográfico de produções Angel
│   │   │       ├── explore_intro.dart         # Hero card e campo de busca inteligente
│   │   │       ├── responsive_media_grid.dart # Grid adaptativo para celulares, desktops e TVs
│   │   │       └── video_card.dart            # Card moderno para vídeos e louvores
│   │   ├── angel/
│   │   │   └── angel_view.dart       # Hub dedicado de Cinema & Séries Angel Studios
│   │   ├── bible/
│   │   │   └── bible_view.dart       # Hub de Leitura Direta e Busca Bíblica (66 Livros)
│   │   ├── bible_study/
│   │   │   └── bible_study_view.dart # Hub de Estudo Bíblico (Vídeos, Louvores, Leitura, Podcasts)
│   │   ├── chapter/
│   │   │   └── chapter_view.dart     # Leitor bíblico com alternância de versões e fontes
│   │   ├── player/
│   │   │   ├── player_view.dart      # Player de vídeo local com suporte a controle remoto / gamepad
│   │   │   └── podcast_player_view.dart # Player nativo de áudio para episódios de podcasts
│   │   └── settings/
│   │       └── settings_view.dart    # Painel de configurações, paletas, acessibilidade e Modo TV
│   │
│   ├── widgets/              # Componentes globais de acessibilidade e navegação
│   │   ├── angel_card.dart           # Exportador de conveniência do AngelCard
│   │   ├── explore_intro.dart        # Componente global do hero card de exploração
│   │   ├── responsive_media_grid.dart# Grade responsiva universal
│   │   ├── tv_focusable.dart         # Destaque com ampliação visual (zoom) e anel luminoso
│   │   ├── tv_remote_scope.dart      # Captura global de eventos de controle remoto e gamepad
│   │   └── video_card.dart           # Card estilizado universal de vídeo
│   │
│   └── services/             # [SERVICES] Fontes de dados, APIs e utilitários
│       ├── angel_service.dart         # Catálogo 100% gratuito sem login de angel.com/pt-BR
│       ├── app_localizations.dart     # Sistema de internacionalização (PT, EN, ES)
│       ├── app_settings_service.dart  # Exportador retrocompatível de settings_controller.dart
│       ├── bible_service.dart         # Provedor bíblico resiliente (ACF, ARA, ARC, WEB)
│       ├── topic_recommendation_service.dart # Motor de extração semântica e tópicos
│       ├── youtube_service.dart       # Busca com cache de vídeos Invidious e Podcasts
│       └── youtube_stream_service.dart# Decodificação paralela de streams com cache e preload
│
└── test/                     # Suíte de testes automatizados unitários e de widget
    ├── angel_studios_test.dart                # Catálogo e extração gratuita de angel.com
    ├── bible_view_test.dart                   # Aba de leitura bíblica e busca de passagens
    ├── home_layout_test.dart                  # Responsividade de layout e navegação adaptativa
    ├── mvc_controllers_test.dart              # Testes unitários dos Controllers MVC
    ├── settings_test.dart                     # Configurações, persistência e acessibilidade
    ├── stream_service_test.dart               # Performance de streaming, cache e preload
    └── topic_recommendation_and_bible_test.dart # Leitor bíblico e motor semântico
```

---

## 🔍 Módulos e Funcionalidades

### 1. Estudo Bíblico & Motor Semântico de Tópicos
Arquivos: [`lib/views/bible_study/bible_study_view.dart`](lib/views/bible_study/bible_study_view.dart) e [`lib/services/topic_recommendation_service.dart`](lib/services/topic_recommendation_service.dart)

* **Prioridade ao Termo do Usuário:** Preserva a consulta digitada sem substituí-la por palavras-chave genéricas.
* **Mapeamento Multitemático Extenso:** Reconhece mais de 29 dimensões existenciais e emocionais (*Perdão a Si Mesmo*, *Amor Próprio e Redenção*, *Luto e Perda*, *Finanças e Família*, *Graça*, *Esperança*, etc.).
* **Reconhecimento Automático de Entidades:** Identifica livros bíblicos, referências (`Salmos 23`, `João 3:16`), personagens (`Rei Davi`, `Moisés`, `Paulo`), cantores e pregadores.
* **4 Sub-abas Integradas:** Alternância entre *Vídeos*, *Louvores*, *Leitura Bíblica* e *Podcasts*.

### 2. Aba Bíblia Sagrada & Leitor de Passagens
Arquivos: [`lib/views/bible/bible_view.dart`](lib/views/bible/bible_view.dart), [`lib/services/bible_service.dart`](lib/services/bible_service.dart) e [`lib/views/chapter/chapter_view.dart`](lib/views/chapter/chapter_view.dart)

* **Aba Principal Dedicada (Aba 1):** Espaço exclusivo para meditação e leitura bíblica contínua no menu principal.
* **Reconhecimento em Tempo Real:** Ao digitar qualquer passagem (ex.: `Salmos 23`, `Sl 91`, `Romanos 8`, `Gênesis 1`), surge um card em destaque **"Passagem reconhecida"** com o botão **"Ler Agora"**.
* **Catálogo Canônico dos 66 Livros:** Filtro rápido por testamento (*Todos 66*, *Antigo 39*, *Novo 27*).
* **Seletor em Grade de Capítulos:** Toque em qualquer livro para abrir um modal interativo com todos os números de capítulos.
* **Chips de Passagens Mais Lidas:** Acesso direto em 1 toque a textos clássicos (*Salmos 23*, *Salmos 91*, *João 3*, *Romanos 8*, *1 Coríntios 13*, *Mateus 5*, *Isaías 53*, *Filipenses 4*).
* **Leitor Bíblico com Doca Flutuante:** Controle dinâmico do tamanho da fonte, alternância de versões (*ACF11*, *ARA*, *ARC09*, *WEB*), cópia de versículo e botões flutuantes para navegar para o capítulo anterior ou seguinte.

### 3. Cinema & Séries Angel Studios (`angel.com/pt-BR`)
Arquivos: [`lib/views/angel/angel_view.dart`](lib/views/angel/angel_view.dart), [`lib/services/angel_service.dart`](lib/services/angel_service.dart) e [`lib/views/home/widgets/angel_card.dart`](lib/views/home/widgets/angel_card.dart)

* **Hub Cinematográfico Dedicado (Aba 2):** Seção exclusiva para assistir a produções cristãs e familiares.
* **100% Gratuito sem Exigência de Cadastro ou Login:**
  * *Os Escolhidos (The Chosen):* Temporada 1 completa e especial de Natal *O Pastor*, totalmente em português.
  * *O Jovem Davi (Young David):* Minissérie de animação épica completa em 5 episódios (*O Guerreiro*, *O Poeta*, *O Pastor*, *O Discípulo* e *O Rei*).
  * *Filmes Bíblicos & Épicos:* *Seu Único Filho (His Only Son)*, *Bonhoeffer*, *Cabrini*, *Depois da Morte (After Death)* e *Som da Liberdade*.
  * *Família & Animação:* *A Saga Asa de Pena* e *Os Gêmeos Tuttle*.
  * *Dry Bar Comedy:* Especiais de humor cristão limpo.
* **Miniaturas Oficiais em Alta Resolução (16:9):** Extração de thumbnails oficiais e mini-pôsteres de contingência.

### 4. Streaming de Vídeos Otimizado (100% no Aplicativo)
Arquivos: [`lib/services/youtube_stream_service.dart`](lib/services/youtube_stream_service.dart) e [`lib/views/player/player_view.dart`](lib/views/player/player_view.dart)

* **Reprodução Forçada no Player Local:** Sem redirecionamentos externos para navegadores.
* **Início Instantâneo (0 ms) via Cache de Streams:** URLs resolvidas permanecem em memória RAM com TTL de 3 horas.
* **Corrida Concorrente Paralela (*Fast Racing*):** Dispara consultas em paralelo entre `YoutubeExplode`, Invidious e Piped via `_firstSuccessful`, adotando a primeira resposta bem-sucedida em poucas centenas de milissegundos.
* **Orçamento Rígido de Resolução (3,2s):** Caso a rede oscile, o player não trava a interface e aciona imediatamente o fallback direto nativo do motor libmpv.
* **Aceleração por Hardware:** Inicialização precoce no `main()` via `MediaKit.ensureInitialized()` e buffer de 32MB pré-alocado.

### 5. Podcasts Cristãos Integrados
Arquivos: [`lib/services/youtube_service.dart`](lib/services/youtube_service.dart), [`lib/controllers/podcast_controller.dart`](lib/controllers/podcast_controller.dart) e [`lib/views/player/podcast_player_view.dart`](lib/views/player/podcast_player_view.dart)

* Catálogo global da **Apple Podcasts** para episódios cristãos com capa de alta resolução e áudio HTTPS.
* Player dedicado com Play/Pause, barra de progresso interativa, avanço e retrocesso, repetição e cache local de buscas.

### 6. Modo TV & Controle Remoto / Gamepads (Interface 10 Pés)
Arquivos: [`lib/widgets/tv_focusable.dart`](lib/widgets/tv_focusable.dart), [`lib/widgets/tv_remote_scope.dart`](lib/widgets/tv_remote_scope.dart) e [`android/app/src/main/AndroidManifest.xml`](android/app/src/main/AndroidManifest.xml)

* **Compatibilidade Android TV & Fire TV:** Manifesto configurado com `android.software.leanback`, banner de TV e categoria `LEANBACK_LAUNCHER`.
* **Destaque Luminoso de Foco (`TvFocusable`):** Efeito de ampliação suave (zoom 1.05x–1.08x) e anel com brilho cromático ao focar qualquer elemento.
* **Mapeamento de Controles Remotos e Gamepads:**
  * **D-pad / Setas:** Navegação de foco bidirecional com auto-scroll centralizado.
  * **Botão A / Select / Enter / OK:** Ativação instantânea de reprodução ou seleção.
  * **Botão B / Esc / Voltar:** Retorno imediato à tela anterior ou fechamento de modais.
  * **L1 / R1 / PageUp / PageDown:** Alternância rápida entre as abas principais.
  * **Botão X / F3:** Focar campo de pesquisa inteligente.
  * **Botão Y / F4:** Alternar Modo TV rapidamente.
  * **Controle no Player de Vídeo:** Setas Esquerda/Direita para retrocesso e avanço de 10s; Enter para Play/Pause.

### 7. Central de Configurações e Acessibilidade
Arquivos: [`lib/views/settings/settings_view.dart`](lib/views/settings/settings_view.dart) e [`lib/controllers/settings_controller.dart`](lib/controllers/settings_controller.dart)

* **Modos de Exibição:** Sistema (automático), Claro ou Escuro.
* **Paleta de Destaques:** *Esmeralda Bíblica*, *Azul Celestial*, *Púrpura Real*, *Âmbar do Deserto*, *Carmesim Sagrado* e *Monocromático*.
* **Modo Alto Contraste:** Otimiza o contraste das fontes, reforça as bordas de cards e inputs e desativa gradientes.
* **Internacionalização Dinâmica:** Suporte a **Português**, **Inglês** e **Espanhol**.
* **Gestão de Cache:** Indicador de capítulos em cache e botão de limpeza instantânea.

---

## ⚡ Otimizações de Desempenho e Caching

| Componente | Técnica Aplicada | Impacto no Desempenho |
| :--- | :--- | :--- |
| **Streams de Vídeo** | Corrida concorrente paralela (`_firstSuccessful`) | Redução de até 50s para menos de 1,5s na resolução |
| **Início de Vídeos** | Cache em memória de streams com TTL de 3h | Início de reprodução em **0 ms** para vídeos visitados |
| **Preload de Streams** | Pré-carregamento ao abrir o hub ou focar cards | Conteúdo pronto para tocar antes mesmo do clique |
| **Pesquisas de Vídeos** | Cache de consultas Invidious com TTL de 20 min | Troca instantânea entre abas de vídeos e louvores |
| **Pesquisas de Podcasts**| Cache em memória de episódios da Apple Podcasts | Eliminação de requisições repetidas |
| **Leitura Bíblica** | Cache em memória de capítulos completos | Leitura e navegação sequencial imediatas |
| **Motor libmpv** | `MediaKit.ensureInitialized()` precoce no `main()` | Eliminação do engasgo na primeira inicialização |

---

## 🛠 Tecnologias e Dependências

| Tecnologia / Pacote | Versão | Finalidade |
| :--- | :--- | :--- |
| **Flutter SDK** | `>=3.4.0 <4.0.0` | Framework de interface multiplataforma nativo |
| **Dart** | `>=3.4.0` | Linguagem de programação fortemente tipada |
| **media_kit** | `^1.2.6` | Motor de reprodução de vídeo baseado em libmpv |
| **media_kit_video** | `^2.0.1` | Renderizador nativo de vídeo para Flutter |
| **media_kit_libs_video** | `^1.0.7` | Bibliotecas nativas compiladas de áudio e vídeo |
| **youtube_explode_dart** | `^3.1.0` | Extração de streams diretos multiplexados |
| **just_audio** | `^0.9.46` | Player de áudio robusto e eficiente para podcasts |
| **just_audio_media_kit** | `^2.1.0` | Suporte a áudio avançado em desktop |
| **shared_preferences** | `^2.5.3` | Persistência assíncrona local de configurações |
| **http** | `^1.3.0` | Cliente HTTP para consumo de APIs REST |
| **url_launcher** | `^6.3.1` | Abertura de links externos de contingência |

---

## 🚀 Como Executar e Compilar

### Pré-requisitos
* Flutter SDK (versão estável instalada e configurada no `PATH`).
* Para Android: Android Studio e Android SDK configurados.
* Para Windows: Visual Studio 2022 com a carga "Desenvolvimento para Desktop com C++".
* Para Linux: Dependências C++ e GTK/libmpv:
  ```bash
  sudo apt-get update && sudo apt-get install -y clang cmake ninja-build pkg-config libgtk-3-dev libmpv-dev
  ```

### Instruções de Instalação e Execução

1. **Obter dependências:**
   ```bash
   flutter pub get
   ```

2. **Executar em modo de desenvolvimento:**
   ```bash
   flutter run
   ```

### Comandos de Build por Plataforma

| Plataforma | Comando de Build | Arquivo de Saída / Localização |
| :--- | :--- | :--- |
| **Android (APK)** | `flutter build apk --release` | `build/app/outputs/flutter-apk/app-release.apk` |
| **Android (AAB)** | `flutter build appbundle --release` | `build/app/outputs/bundle/release/app-release.aab` |
| **Windows** | `flutter build windows --release` | `build/windows/x64/runner/Release/verbo_vivo.exe` |
| **macOS** | `flutter build macos --release` | `build/macos/Build/Products/Release/verbo_vivo.app` |
| **Linux** | `flutter build linux --release` | `build/linux/x64/release/bundle/verbo_vivo` |
| **iOS** | `flutter build ipa --release` | `build/ios/archive/Runner.xcarchive` |

---

## 🧪 Suíte de Testes e Qualidade

O projeto mantém cobertura completa de testes unitários, testes de controllers e testes de layout:

```bash
# Execução da suíte completa de testes
flutter test
```

### Arquivos de Teste
1. **`test/home_layout_test.dart`**: Valida a responsividade mobile vs. desktop, o `NavigationBar` de 4 abas, `NavigationRail` e Modo TV.
2. **`test/bible_view_test.dart`**: Testa a renderização da Bíblia Sagrada, catálogo dos 66 livros, filtros de testamento, busca de livros e reconhecimento de referências bíblicas.
3. **`test/angel_studios_test.dart`**: Testa o catálogo gratuito de angel.com/pt-BR, categorização (*The Chosen*, *O Jovem Davi*, Filmes) e conversão para itens de vídeo.
4. **`test/stream_service_test.dart`**: Testa o sistema de cache de streams, pré-carregamento (*preload*) e tempo de resposta instantâneo (< 50ms).
5. **`test/mvc_controllers_test.dart`**: Valida o `HomeController`, `ChapterController`, `PodcastController` e fluxo de estados do padrão MVC.
6. **`test/settings_test.dart`**: Testa o `SettingsController`, persistência no `SharedPreferences`, acessibilidade e internacionalização.
7. **`test/topic_recommendation_and_bible_test.dart`**: Testa o parser de referências bíblicas e o motor semântico para buscas extensas e emocionais.

---

## 🌐 Fontes de Dados e Créditos

* **Bolls Life API:** Provedor de textos bíblicos integrais em português (ACF11, ARA, ARC) e outras versões.
* **Angel Studios (`angel.com/pt-BR`):** Catálogo selecionado de produções audiovisuais gratuitas de fé e família.
* **Apple Podcasts API:** Catálogo nacional e episódios de podcasts cristãos edificantes.
* **Invidious Project & YouTubeExplode:** Resolução de streams e vídeos de estudo e louvor.
* **libmpv / MediaKit:** Motor de decodificação e renderização de vídeo acelerado por hardware.

---

## 📄 Licença

Este projeto é disponibilizado sob uso educacional e ministerial. Consulte o arquivo `LICENSE` no repositório para detalhes sobre permissões e termos de distribuição.
