
## Vue d'ensemble

Le `match` statement en GDScript est l'équivalent du `switch` dans d'autres langages. Il permet de comparer une valeur contre plusieurs patterns et d'exécuter du code spécifique selon le cas correspondant. Il est particulièrement puissant quand utilisé avec des enums.

## Définition d'un Enum

```gdscript
enum Alignment { ALLY, NEUTRAL, ENEMY }
```

### Points clés sur les Enums :

- **Lisibilité** : Remplace les "magic numbers" par des noms explicites
- **Type safety** : Évite les erreurs de typage
- **Autocomplétion** : L'éditeur peut suggérer les valeurs possibles
- **Valeurs automatiques** : `ALLY = 0`, `NEUTRAL = 1`, `ENEMY = 2`

## Variable exportée avec Enum

```gdscript
@export var unit_alignment: Alignment
```

### Avantages de `@export` avec un enum :

- **Interface utilisateur** : Crée automatiquement un dropdown dans l'inspecteur
- **Validation** : Empêche l'assignation de valeurs invalides
- **Facilité d'usage** : Les designers peuvent modifier les valeurs sans toucher au code

## Structure Match complète

```gdscript
enum Alignment { ALLY, NEUTRAL, ENEMY }
@export var unit_alignment: Alignment

func _ready():
    match unit_alignment:  # Note: utilise unit_alignment au lieu de my_alignment
        Alignment.ALLY:
            print("Hello my friend")
        Alignment.NEUTRAL:
            print("Come in peace!")
        Alignment.ENEMY:
            print("I KILL U")
        _:  # Cas par défaut (wildcard)
            print("Who are you?")
```

## Fonctionnalités avancées du Match

### 1. Patterns multiples

```gdscript
match unit_alignment:
    Alignment.ALLY, Alignment.NEUTRAL:
        print("You seem friendly")
    Alignment.ENEMY:
        print("Prepare for battle!")
```

### 2. Match avec conditions (guards)

```gdscript
match [unit_alignment, health]:
    [Alignment.ALLY, var h] when h > 50:
        print("Strong ally!")
    [Alignment.ALLY, var h] when h <= 50:
        print("Wounded ally needs help")
```

### 3. Match avec des types

```gdscript
match node:
    Area2D:
        print("This is an Area2D")
    RigidBody2D:
        print("This is a RigidBody2D")
    _:
        print("Unknown node type")
```

## Bonnes pratiques

### ✅ À faire :

- Toujours inclure un cas par défaut `_` pour gérer les valeurs inattendues
- Utiliser des enums plutôt que des constantes pour les groupes de valeurs liées
- Nommer les enums avec PascalCase et les valeurs en UPPER_CASE

### ❌ À éviter :

- Oublier le cas par défaut (peut causer des bugs silencieux)
- Utiliser des "magic numbers" au lieu d'enums
- Créer des enums trop larges (préférer plusieurs petits enums spécialisés)

## Exemple pratique : Système de combat

```gdscript
extends Node2D

enum Alignment { ALLY, NEUTRAL, ENEMY }
enum ActionType { ATTACK, DEFEND, HEAL, FLEE }

@export var unit_alignment: Alignment
@export var current_action: ActionType

func process_action():
    match [unit_alignment, current_action]:
        [Alignment.ALLY, ActionType.HEAL]:
            print("Ally heals the party")
        [Alignment.ENEMY, ActionType.ATTACK]:
            print("Enemy attacks!")
        [Alignment.NEUTRAL, ActionType.FLEE]:
            print("Neutral unit flees the battle")
        [_, ActionType.DEFEND]:
            print("Unit takes defensive stance")
        _:
            print("Default action")
```

## Notes importantes

- Le `match` en GDScript est plus puissant que le `switch` classique
- Il supporte le pattern matching avancé (arrays, dictionaries, types)
- Plus performant qu'une série de `if/elif` pour de nombreux cas
- Exhaustivité : le compilateur peut détecter si tous les cas ne sont pas couverts