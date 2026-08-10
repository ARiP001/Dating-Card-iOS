# DatingCard structure

```text
DatingCard/
├── App/
│   └── Navigation/                 # App entry point and navigation coordinator
├── Core/
│   ├── DesignSystem/               # Reusable theme, typography, colors, spacing
│   ├── Extensions/                 # General-purpose extensions
│   └── Utilities/                  # Small shared helpers
├── Features/
│   ├── Onboarding/
│   │   ├── Presentation/{Views, ViewModels}/
│   │   └── Domain/Models/
│   ├── Main/
│   │   ├── Home/{Presentation, Domain}/
│   │   └── History/{Presentation, Domain}/
│   ├── ChoosePreferences/
│   │   ├── AppClip/Presentation/{Views, ViewModels}/
│   │   └── TurnBased/Presentation/{Views, ViewModels}/
│   ├── WouldYouRather/{Presentation, Domain}/
│   ├── Gameplay/{Presentation, Domain}/
│   └── Shared/Components/          # Components shared only by features
├── Resources/
│   └── Assets/
└── Extensions/                     # Existing project extensions; migrate gradually to Core
```

## Placement rules

- Place a screen and its view model in the same feature. For example, `HomeView.swift` belongs in `Features/Main/Home/Presentation/Views`.
- Keep a model inside its feature unless two or more features genuinely use it. Move it to `Core` only then.
- Add `Data/Repositories` to a feature only when it starts loading or persisting data. Do not add empty repository protocols prematurely.
- Put UI components used by one feature inside that feature; use `Features/Shared/Components` only when multiple features need them.
- Keep `App` limited to app startup, root routing, and tab/navigation composition.
