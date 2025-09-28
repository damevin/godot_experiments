## Concept de base

Les signals permettent à un objet de communiquer avec d'autres objets. Un signal dit "quelque chose s'est passé" et d'autres objets peuvent "écouter" et réagir.

## Syntaxe des signals

### Déclaration d'un signal

```gdscript
signal leveled_up(msg)  # Signal avec paramètre
signal player_died      # Signal sans paramètre
```

### Connexion (écoute du signal)

```gdscript
func _ready():
    leveled_up.connect(_on_leveled_up)  # Connecte le signal à une fonction
```

### Émission (déclencher le signal)

```gdscript
leveled_up.emit("GG!")  # Déclenche le signal avec un paramètre
```

## Exemple complet

```gdscript
signal leveled_up(msg)
var xp := 0

func _ready():
    leveled_up.connect(_on_leveled_up)  # Écoute du signal

func _on_timer_timeout():
    xp += 5
    print(xp)
    if xp >= 20:
        xp = 0
        leveled_up.emit("GG!")  # Déclenche le signal

func _on_leveled_up(msg):
    print(msg)  # Fonction qui réagit au signal
```

## Signals entre différents nœuds

### Dans le nœud émetteur (Player)

```gdscript
extends CharacterBody2D

signal health_changed(new_health)
var health = 100

func take_damage(damage):
    health -= damage
    health_changed.emit(health)  # Émet le signal
```

### Dans le nœud récepteur (UI)

```gdscript
extends Control

@onready var health_bar = $HealthBar
@onready var player = get_node("../Player")

func _ready():
    player.health_changed.connect(_on_player_health_changed)

func _on_player_health_changed(new_health):
    health_bar.value = new_health  # Met à jour l'UI
```

## Signals avec plusieurs paramètres

```gdscript
signal item_collected(item_name, quantity, rarity)

func collect_item():
    var item = "Sword"
    var qty = 1
    var rarity = "Rare"
    
    item_collected.emit(item, qty, rarity)

func _on_item_collected(name, quantity, rarity):
    print("Collected %d %s %s" % [quantity, rarity, name])
```

## Déconnexion de signals

```gdscript
func _ready():
    leveled_up.connect(_on_leveled_up)

func cleanup():
    if leveled_up.is_connected(_on_leveled_up):
        leveled_up.disconnect(_on_leveled_up)
```

## Avantages des signals

- **Découplage** : Les objets n'ont pas besoin de se connaître directement
- **Flexibilité** : Plusieurs objets peuvent écouter le même signal
- **Organisation** : Code plus propre et modulaire

## Cas d'usage typiques

### Communication Player → UI

```gdscript
# Player émet des changements d'état
signal health_changed(health)
signal mana_changed(mana)
signal level_up(new_level)

# UI écoute et met à jour l'affichage
```

### Communication entre objets de jeu

```gdscript
# Ennemi émet sa mort
signal enemy_died(enemy_type, position)

# GameManager écoute pour spawn des items
# AudioManager écoute pour jouer un son
```

## Bonnes pratiques

**✅ À faire :**

- Noms de signals descriptifs (`health_changed`, `item_collected`)
- Utiliser des paramètres pour transmettre les données importantes
- Connecter les signals dans `_ready()`

**❌ À éviter :**

- Trop de paramètres dans un signal (max 3-4)
- Oublier de déconnecter les signals si nécessaire
- Signals trop génériques (`something_happened`)