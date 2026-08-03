# Design System PCPE

> **Polícia Civil de Pernambuco** — Departamento de Homicídios e Proteção à Pessoa
>
> Sistema de Registro de Atendimento em Local de Crime

---

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Estrutura de Arquivos](#estrutura-de-arquivos)
3. [Cores (PCPEColors)](#cores-pcpecolors)
4. [Tipografia (PCPETypography)](#tipografia-pcpetography)
5. [Espaçamento (PCPESpacing)](#espaçamento-pcpespacing)
6. [Border Radius (PCPEBorderRadius)](#border-radius-pcpeborderradius)
7. [Sombras (PCPEShadows)](#sombras-pcpeshadows)
8. [Ícones (PCPEIcons)](#ícones-pcpeicons)
9. [Animações (PCPEAnimations)](#animações-pcpeanimations)
10. [Tema (PCPETheme)](#tema-pcpetheme)
11. [Componentes](#componentes)
12. [Responsividade](#responsividade)
13. [Boas Práticas](#boas-práticas)

---

## Visão Geral

O Design System da PCPE unifica a identidade visual do sistema de registro de atendimentos em locais de crime. Ele é construído sobre o **Material Design 3** e utiliza as fontes **Montserrat** (headlines) e **Inter** (corpo), garantindo legibilidade e hierarquia visual clara.

### Princípios

- **Consistência**: Tokens reutilizáveis em toda a aplicação
- **Acessibilidade**: Contraste WCAG AA em todos os elementos
- **Escalabilidade**: Sistema modular com 8pt grid
- **Institucional**: Identidade alinhada à Polícia Civil de Pernambuco

---

## Estrutura de Arquivos

```
frontend/lib/design_system/
├── design_system.dart          # Barrel file (importação única)
├── pcpe_colors.dart            # Paleta de cores
├── pcpe_typography.dart        # Sistema tipográfico
├── pcpe_spacing.dart           # Escala de espaçamento (8pt grid)
├── pcpe_border_radius.dart     # Cantos arredondados
├── pcpe_shadows.dart           # Sombras
├── pcpe_icons.dart             # Ícones padronizados
├── pcpe_animations.dart        # Durações e curvas de animação
└── pcpe_theme.dart             # ThemeData central (Material 3)
```

### Como Importar

```dart
// Importação completa (recomendada)
import 'package:pcpe_frontend/design_system/design_system.dart';

// Ou tokens individuais
import 'package:pcpe_frontend/design_system/pcpe_colors.dart';
```

---

## Cores (PCPEColors)

Baseada no **azul institucional (#0D47A1)** da Polícia Civil de Pernambuco.

### Paleta Principal

| Token            | Hex       | Preview | Uso                         |
|------------------|-----------|---------|-----------------------------|
| `primary`        | `#0D47A1` | ███████ | Ações primárias, ícones     |
| `primaryDark`    | `#093170` | ███████ | Gradientes, hover states    |
| `primaryLight`   | `#1565C0` | ███████ | Links, estados secundários  |
| `primarySoft`    | `#E3F2FD` | ███████ | Backgrounds de destaque     |

### Neutras

| Token            | Hex       | Uso                           |
|------------------|-----------|-------------------------------|
| `black`          | `#1A1A1A` | Texto principal               |
| `darkGray`       | `#37474F` | Texto secundário              |
| `mediumGray`     | `#78909C` | Placeholders, disabled        |
| `lightGray`      | `#B0BEC5` | Borders, dividers             |
| `surfaceGray`    | `#ECEFF1` | Superfícies elevadas          |
| `cardGray`       | `#F5F7FA` | Background de inputs/cards    |
| `white`          | `#FAFAFA` | Background alternativo        |
| `pureWhite`      | `#FFFFFF` | Cards, AppBar                |
| `background`     | `#EEF1F5` | Scaffold background           |

### Semânticas

| Token            | Hex       | Uso                   |
|------------------|-----------|-----------------------|
| `error`          | `#D32F2F` | Erros, exclusão       |
| `errorLight`     | `#FFEBEE` | Background de erro    |
| `success`        | `#2E7D32` | Confirmação, sucesso  |
| `successLight`   | `#E8F5E9` | Background de sucesso |
| `warning`        | `#EF6C00` | Alertas               |
| `warningLight`   | `#FFF3E0` | Background de alerta  |
| `info`           | `#1565C0` | Informações           |
| `infoLight`      | `#E3F2FD` | Background de info    |

---

## Tipografia (PCPETypography)

### Font Families

- **Display/Heading**: Montserrat (bold, imponente)
- **Body/UI**: Inter (limpa, legível)

### Escala Tipográfica

| Token              | Font        | Size | Weight   | Uso                        |
|--------------------|-------------|------|----------|----------------------------|
| `displayLarge`     | Montserrat  | 32   | Bold     | Títulos de página          |
| `displayMedium`    | Montserrat  | 28   | Bold     | Subtítulos hero            |
| `displaySmall`     | Montserrat  | 24   | W600     | Cabeçalhos de seção        |
| `headlineLarge`    | Montserrat  | 22   | W600     | Títulos de card            |
| `headlineMedium`   | Montserrat  | 20   | W600     | Títulos de diálogo         |
| `headlineSmall`    | Montserrat  | 18   | W600     | Subtítulos                 |
| `titleLarge`       | Inter       | 18   | W600     | Títulos de lista           |
| `titleMedium`      | Inter       | 16   | W500     | Itens de menu              |
| `titleSmall`       | Inter       | 14   | W500     | Labels de campo            |
| `bodyLarge`        | Inter       | 16   | Normal   | Parágrafos                 |
| `bodyMedium`       | Inter       | 14   | Normal   | Texto padrão               |
| `bodySmall`        | Inter       | 12   | Normal   | Metadados, legendas        |
| `labelLarge`       | Inter       | 14   | W600     | Botões, CTAs               |
| `labelMedium`      | Inter       | 12   | W500     | Labels secundários         |
| `labelSmall`       | Inter       | 10   | W500     | Overlines, badges pequenos |

### Especiais

| Token       | Font   | Size | Weight | Uso                  |
|-------------|--------|------|--------|----------------------|
| `badge`     | Inter  | 10   | W700   | Badges, contadores   |
| `overline`  | Inter  | 10   | W700   | Categorias, seções   |

---

## Espaçamento (PCPESpacing)

Sistema baseado em **incrementos de 4px** (8pt grid system).

| Token      | Value | Uso                                |
|------------|-------|------------------------------------|
| `xs`       | 4px   | Mínimo (ícone-texto, badges)       |
| `sm`       | 8px   | Pequeno (dentro de chips)          |
| `mdSm`     | 12px  | Médio-pequeno (espaçamento médio)  |
| `md`       | 16px  | Médio (padding padrão de tela)     |
| `mdLg`     | 20px  | Médio-grande (card interno)        |
| `lg`       | 24px  | Grande (seções)                    |
| `xl`       | 28px  | Extra-grande (login card padding)  |
| `xxl`      | 32px  | 2xl                                |
| `xxxl`     | 40px  | 3xl (espaçamento entre seções)     |
| `huge`     | 48px  | 4xl                                |
| `giant`    | 56px  | Gigante (avatar splash)            |

### Constantes de Layout

| Constante            | Value | Uso                           |
|----------------------|-------|-------------------------------|
| `screenHorizontal`   | 16    | Padding horizontal padrão     |
| `screenVertical`     | 8     | Padding vertical de tela      |
| `cardInner`          | 20    | Padding interno de cards      |
| `inputHeight`        | 48    | Altura padrão de inputs       |
| `controlSmall`       | 38    | Altura pequena (botões small) |
| `railWidth`          | 72    | Largura do NavigationRail     |
| `drawerWidth`        | 280   | Largura do Drawer             |

---

## Border Radius (PCPEBorderRadius)

| Token    | Value | Uso                                   |
|----------|-------|---------------------------------------|
| `xs`     | 4px   | Checkboxes, inputs pequenos           |
| `sm`     | 8px   | Chips, badges                         |
| `md`     | 10px  | Botões, inputs, menu items            |
| `mdLg`   | 12px  | Avatares pequenos                     |
| `lg`     | 14px  | Cards, FAB, containers principais     |
| `xl`     | 18px  | Cards de login, diálogos              |
| `xxl`    | 20px  | Chips arredondados, tags              |
| `huge`   | 24px  | Avatares médios, splash icons         |
| `giant`  | 28px  | Avatares grandes (splash screen)      |

### Shortcuts

```dart
PCPEBorderRadius.card     // BorderRadius.all(14)
PCPEBorderRadius.dialog   // BorderRadius.all(18)
PCPEBorderRadius.button   // BorderRadius.all(10)
PCPEBorderRadius.input    // BorderRadius.all(10)
PCPEBorderRadius.chip     // BorderRadius.all(20)
PCPEBorderRadius.avatar   // BorderRadius.all(12)
PCPEBorderRadius.fab      // BorderRadius.all(14)
PCPEBorderRadius.menu     // BorderRadius.all(10)
```

---

## Sombras (PCPEShadows)

| Token            | Elevação | Uso                                 |
|------------------|----------|-------------------------------------|
| `subtle`         | 2px      | Inputs, cards plain                 |
| `card`           | 2px      | Cards padrão                        |
| `medium`         | 4px      | Diálogos, popups                    |
| `elevated`       | 6px      | FAB, bottom nav, drawer             |
| `floating`       | 8px      | Tooltips, dropdowns                 |
| `auth`           | 6px      | Cards de login/autenticação         |
| `sideMenuHeader` | 4px      | Header do side menu                 |
| `bottomNav`      | -2px     | Bottom navigation bar               |
| `primaryButton`  | 2px      | Botão primário (sombra azul)        |
| `fab`            | 4px      | Floating Action Button (sombra azul)|

---

## Ícones (PCPEIcons)

Mapeamento de ícones do Material Design para contextos da PCPE.

### Categorias

| Categoria       | Exemplos                                              |
|-----------------|-------------------------------------------------------|
| **Brand**       | `shield`, `badge`, `fingerprint`                      |
| **Navegação**   | `dashboard`, `notifications`, `logout`, `arrowForward` |
| **Ações**       | `add`, `edit`, `delete`, `sync`, `filter`             |
| **Autenticação**| `login`, `lock`, `badgeIcon`, `visibility`            |
| **Módulos**     | `ocorrencias`, `atendimentos`, `vestigios`, `veiculos`|
| **Status**      | `success`, `warning`, `error`, `clock`                |
| **Sistema**     | `settings`, `about`, `profile`, `history`             |

### Extensão de Tamanhos

```dart
// Uso com a extensão
PCPEIcons.shield.icon40(color: PCPEColors.primary)
PCPEIcons.dashboard.icon20()
PCPEIcons.checkCircle.icon16()
```

---

## Animações (PCPEAnimations)

### Durações

| Token          | Value  | Uso                                     |
|----------------|--------|-----------------------------------------|
| `fast`         | 150ms  | Hover, feedback tátil                   |
| `normal`       | 200ms  | Transições simples, mudanças de cor     |
| `medium`       | 300ms  | Expansão de cards, troca de tela        |
| `slow`         | 500ms  | Transições de página, modais            |
| `splash`       | 1800ms | Animação de entrada (splash screen)     |
| `splashDelay`  | 3000ms | Delay até redirecionar do splash        |

### Curvas

| Token             | Curva               | Uso                          |
|-------------------|---------------------|------------------------------|
| `standard`        | `easeInOut`         | Transições padrão            |
| `easeOut`         | `easeOut`           | Entradas suaves              |
| `easeOutBack`     | `easeOutBack`       | Animações de destaque        |
| `decelerate`      | `decelerate`        | Desaceleração                |
| `fastOutSlowIn`   | `fastOutSlowIn`     | Animações responsivas        |

### Transições de Página

```dart
// Slide from right (navegação forward)
PCPEAnimations.slideFromRight(animation, child)

// Fade simples
PCPEAnimations.fade(animation, child)

// AnimatedContainer com defaults do DS
PCPEAnimations.animatedContainer(child: myWidget)
```

---

## Tema (PCPETheme)

Centraliza todos os tokens em um `ThemeData` Material 3.

```dart
// Uso no MaterialApp
MaterialApp.router(
  theme: PCPETheme.light,
  // ...
)
```

O tema configura automaticamente:
- AppBar (fundo branco, sem elevação)
- Cards (borda sutil, sombra suave)
- Botões (elevated/outlined no padrão institucional)
- Inputs (filled com cardGray)
- Bottom Navigation Bar
- Navigation Rail
- SnackBar, Dialog, Chip, FAB

---

## Componentes

O sistema possui componentes reutilizáveis em `lib/shared/widgets/`:

| Componente             | Arquivo                   | Descrição                          |
|------------------------|---------------------------|------------------------------------|
| `PCPEButton`           | `pcpe_button.dart`        | Botão primário/outlined             |
| `PCPECard`             | `pcpe_card.dart`          | Card com borda e sombra padrão      |
| `PCPEInput`            | `pcpe_input.dart`         | Input de texto padronizado          |
| `PCPEHeader`           | `pcpe_header.dart`        | AppBar customizada                  |
| `PCPESideMenu`         | `pcpe_side_menu.dart`     | Menu lateral (Drawer)               |
| `PCPEAvatar`           | `pcpe_avatar.dart`        | Avatar com iniciais                 |
| `PCPEStatusChip`       | `pcpe_status_chip.dart`   | Chip de status colorido             |
| `PCPESectionTitle`     | `pcpe_section_title.dart` | Título de seção com ícone           |
| `PCPEStatisticCard`    | `pcpe_statistic_card.dart`| Card de estatística (dashboard)     |
| `DashboardShell`       | `dashboard_shell.dart`    | Layout responsivo (drawer/rail/nav) |

---

## Responsividade

O sistema utiliza `responsive_framework` com os seguintes breakpoints:

| Nome      | Range         | Layout                              |
|-----------|---------------|-------------------------------------|
| `MOBILE`  | 0 – 600px     | Bottom nav + Drawer                 |
| `TABLET`  | 601 – 900px   | Navigation Rail + Drawer opcional   |
| `DESKTOP` | 901 – 1200px  | Side menu fixo + AppBar completa    |
| `4K`      | 1201px+       | Side menu fixo + Conteúdo amplo     |

### Comportamentos por Breakpoint

- **Mobile**: Bottom navigation bar, drawer acessível por hamburguer menu
- **Tablet**: Navigation rail (72px) à esquerda, drawer disponível
- **Desktop**: AppBar completa com avatar, notificações e menu dropdown

---

## Boas Práticas

### Cores
```dart
// ✅ Use os tokens do Design System
color: PCPEColors.primary

// ❌ Não use valores hardcoded
color: Color(0xFF0D47A1)
```

### Tipografia
```dart
// ✅ Use os tokens tipográficos
style: PCPETypography.headlineLarge

// ❌ Não redefina estilos manualmente
style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)
```

### Espaçamento
```dart
// ✅ Use a escala de espaçamento
padding: const EdgeInsets.all(PCPESpacing.md)

// ❌ Não use valores arbitrários
padding: const EdgeInsets.all(15)
```

### Ícones
```dart
// ✅ Use os ícones padronizados com extensão de tamanho
PCPEIcons.shield.icon20(color: PCPEColors.primary)

// ❌ Não use ícones soltos sem padronização
Icon(Icons.shield, size: 20, color: PCPEColors.primary)
```

### Importação
```dart
// ✅ Importação única do barrel
import 'package:pcpe_frontend/design_system/design_system.dart';

// ❌ Múltiplas importações
import 'package:pcpe_frontend/design_system/pcpe_colors.dart';
import 'package:pcpe_frontend/design_system/pcpe_typography.dart';
// ...
```

---

## Versionamento

| Versão | Data       | Descrição                                    |
|--------|------------|----------------------------------------------|
| 1.0.0  | 2026-08-03 | Design System inicial com tokens e tema M3   |

---

> **© Polícia Civil de Pernambuco** — Desenvolvido pela UNISA