## Concept de base

Les getters et setters permettent de contrôler comment on lit et écrit les valeurs d'une variable. Utile pour valider les données ou déclencher des actions lors des changements.

## Setter avec validation

```gdscript
extends Node
signal health_changed(new_health)

var health := 100:
    set(value):
        # Validation : santé entre 0 et 100
        health = clamp(value, 0, 100)
        health_changed.emit(health)

func _ready():
    health = -150  # Sera automatiquement limité à 0
    
func _on_health_changed(new_health):
    print(new_health)  # Affiche : 0
```

**Points clés :**

- `set(value)` s'exécute à chaque assignation
- `clamp(value, 0, 100)` limite la valeur entre 0 et 100
- Le signal est émis automatiquement à chaque changement

## Getter et Setter combinés

```gdscript
extends Node

var chance := 0.2
var chance_pct: int:
    get:
        return chance * 100  # Convertit 0.2 en 20
    set(value):
        chance = float(value) / 100.0  # Convertit 40 en 0.4

func _ready():
    print(chance_pct)    # 20 (0.2 * 100)
    chance_pct = 40      # Stocke 0.4 dans chance
    print(chance_pct)    # 40 (0.4 * 100)
```

**Ce qui se passe :**

- `get` : Quand on lit `chance_pct`, retourne `chance * 100`
- `set` : Quand on écrit `chance_pct = 40`, convertit en `chance = 0.4`

## Exemples pratiques

### Validation de niveau

```gdscript
var level := 1:
    set(value):
        if value >= 1 and value <= 100:
            level = value
            print("Level set to: %d" % level)
        else:
            print("Invalid level: %d" % value)
```

### Conversion automatique

```gdscript
var speed_kmh := 50.0
var speed_ms: float:
    get:
        return speed_kmh / 3.6  # km/h vers m/s
    set(value):
        speed_kmh = value * 3.6  # m/s vers km/h
```

### Mise à jour d'UI automatique

```gdscript
extends Control

@onready var label = $ScoreLabel
var score := 0:
    set(value):
        score = value
        if label:
            label.text = "Score: %d" % score

func _ready():
    score = 100  # Met automatiquement à jour le label
```

## Setter avec conditions

```gdscript
var player_name := "":
    set(value):
        if value.length() >= 3:
            player_name = value
            print("Name changed to: %s" % player_name)
        else:
            print("Name too short!")

var age := 0:
    set(value):
        if value >= 0 and value <= 120:
            age = value
        else:
            print("Invalid age: %d" % value)
```

## Getter calculé (sans variable de stockage)

```gdscript
var x := 10.0
var y := 20.0

# Variable calculée, pas de stockage
var distance_from_origin: float:
    get:
        return sqrt(x * x + y * y)
    # Pas de set = lecture seule

func _ready():
    print(distance_from_origin)  # Calcule la distance
    x = 30
    print(distance_from_origin)  # Nouveau calcul automatique
```

## Cas d'usage courants

### 1. États de jeu

```gdscript
var game_state := "menu":
    set(value):
        var old_state = game_state
        game_state = value
        print("Game state: %s -> %s" % [old_state, game_state])
        # Logique de transition d'état ici
```

### 2. Ressources avec maximum

```gdscript
var max_mana := 100
var current_mana := 100:
    set(value):
        current_mana = clamp(value, 0, max_mana)
        mana_changed.emit(current_mana, max_mana)
```

### 3. Propriétés dérivées

```gdscript
var first_name := "John"
var last_name := "Doe"
var full_name: String:
    get:
        return "%s %s" % [first_name, last_name]
    set(value):
        var parts = value.split(" ")
        if parts.size() >= 2:
            first_name = parts[0]
            last_name = parts[1]
```

## Bonnes pratiques

**✅ À faire :**

- Utiliser pour la validation de données
- Combiner avec des signals pour notifier les changements
- Valider les entrées dans les setters
- Utiliser pour des conversions automatiques

**❌ À éviter :**

- Logique trop complexe dans les getters/setters
- Effets de bord inattendus
- Setters qui modifient d'autres variables sans raison claire

## Notes importantes

- Le setter est appelé même lors de l'assignation initiale
- Les getters sont appelés à chaque lecture de la variable
- Attention aux boucles infinies (setter qui modifie la même variable)
- Parfait pour maintenir la cohérence des données