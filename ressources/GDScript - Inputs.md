## Vue d'ensemble

Godot utilise des lifecycle hooks (méthodes de cycle de vie) pour exécuter du code à des moments précis. Le système d'input permet de réagir aux actions du joueur de manière flexible et organisée.

## Lifecycle Hook : `_ready()`

### Définition

`_ready()` est appelée une seule fois quand le nœud entre dans la scène et que tous ses enfants sont initialisés.

```gdscript
func _ready():
    # Initialisation du nœud
    $Label.text = "Coucou"
    $Label.modulate = Color.GREEN
    print("Le nœud est prêt !")
```

### Caractéristiques importantes :

- **Moment d'exécution** : Après que tous les nœuds enfants soient prêts
- **Fréquence** : Une seule fois par instance de nœud
- **Usage typique** : Configuration initiale, connexion de signaux, initialisation de variables

### Autres lifecycle hooks utiles :

```gdscript
func _enter_tree():
    # Appelé quand le nœud entre dans l'arbre de scène
    print("Nœud ajouté à la scène")

func _exit_tree():
    # Appelé quand le nœud quitte l'arbre de scène
    print("Nœud retiré de la scène")

func _process(delta):
    # Appelé à chaque frame
    # delta = temps écoulé depuis la dernière frame
    pass

func _physics_process(delta):
    # Appelé à chaque frame de physique (généralement 60 FPS)
    # Utilisé pour les mouvements et calculs physiques
    pass
```

## Input Handling : `_input(event)`

### Principe de base

`_input()` est un "listener" global qui capture tous les événements d'entrée (clavier, souris, manette, etc.).

```gdscript
func _input(event):
    if event.is_action_pressed('my_action'):
        $Label.modulate = Color.RED
        print("Action pressée !")
        
    if event.is_action_released('my_action'):
        $Label.modulate = Color.GREEN
        print("Action relâchée !")
```

## Configuration des Input Maps

### Dans l'éditeur :

1. **Project** → **Project Settings** → **Input Map**
2. Ajouter une nouvelle action (ex: `my_action`)
3. Assigner des touches/boutons à cette action

### Par code :

```gdscript
# Vérifier si une action existe
if InputMap.has_action("my_action"):
    print("L'action existe")

# Ajouter une action dynamiquement
InputMap.add_action("new_action")
var event = InputEventKey.new()
event.keycode = KEY_SPACE
InputMap.action_add_event("new_action", event)
```

## Types d'événements d'input

### 1. Actions (recommandé)

```gdscript
func _input(event):
    if event.is_action_pressed("jump"):
        jump()
    if event.is_action_just_pressed("interact"):
        interact()  # Une seule fois au moment de presser
    if event.is_action_just_released("shoot"):
        stop_shooting()
```

### 2. Input direct

```gdscript
func _input(event):
    if event is InputEventKey:
        if event.keycode == KEY_SPACE and event.pressed:
            print("Espace pressé")
    
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            print("Clic gauche")
```

## Différences entre les méthodes d'input

### `_input(event)` vs `_unhandled_input(event)`

```gdscript
# _input : Reçoit TOUS les événements
func _input(event):
    if event.is_action_pressed("pause"):
        pause_game()
    # Empêche la propagation
    get_viewport().set_input_as_handled()

# _unhandled_input : Reçoit seulement les événements non traités par l'UI
func _unhandled_input(event):
    if event.is_action_pressed("move_left"):
        move_left()  # Ne sera pas appelé si l'UI a géré l'événement
```

## Exemple pratique : Contrôle de personnage

```gdscript
extends CharacterBody2D

@export var speed: float = 200.0
@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $UI/Label

func _ready():
    label.text = "Utilisez WASD pour bouger"
    sprite.modulate = Color.WHITE

func _input(event):
    # Gestion des actions spéciales
    if event.is_action_pressed("sprint"):
        speed *= 2
        sprite.modulate = Color.YELLOW
        label.text = "SPRINT ACTIVÉ !"
    
    if event.is_action_released("sprint"):
        speed /= 2
        sprite.modulate = Color.WHITE
        label.text = "Utilisez WASD pour bouger"

func _physics_process(delta):
    # Gestion du mouvement continu
    var input_vector = Vector2.ZERO
    
    if Input.is_action_pressed("move_left"):
        input_vector.x -= 1
    if Input.is_action_pressed("move_right"):
        input_vector.x += 1
    if Input.is_action_pressed("move_up"):
        input_vector.y -= 1
    if Input.is_action_pressed("move_down"):
        input_vector.y += 1
    
    velocity = input_vector.normalized() * speed
    move_and_slide()
```

## Méthodes utiles pour les inputs

### Vérification d'état

```gdscript
# Dans _process() ou _physics_process()
if Input.is_action_pressed("jump"):
    # Maintenu
    charge_jump()

if Input.is_action_just_pressed("attack"):
    # Une seule frame au moment de presser
    attack()

if Input.is_action_just_released("bow"):
    # Une seule frame au moment de relâcher
    shoot_arrow()
```

### Récupération de valeurs

```gdscript
# Pour les axes (manettes, claviers directionnels)
var horizontal = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
var vertical = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

# Ou plus simple avec des actions composées
var move_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
```

## Bonnes pratiques

### ✅ À faire :

- Utiliser les Input Maps plutôt que les touches directes
- Séparer les actions ponctuelles (`_input`) des actions continues (`_physics_process`)
- Nommer les actions de manière descriptive (`jump`, `interact`, `menu_open`)
- Utiliser `_unhandled_input` pour les contrôles de gameplay

### ❌ À éviter :

- Mélanger `_input` et `Input.is_action_pressed()` pour la même action
- Oublier de configurer les Input Maps avant de tester
- Utiliser `_input` pour des actions continues (préférer `_physics_process`)

## Organisation du code

```gdscript
extends Node2D

# Variables
@onready var player: CharacterBody2D = $Player
@onready var ui: Control = $UI

func _ready():
    # Initialisation
    setup_ui()

func _input(event):
    # Actions ponctuelles globales
    handle_global_actions(event)

func _unhandled_input(event):
    # Actions de gameplay
    handle_gameplay_actions(event)

func handle_global_actions(event):
    if event.is_action_just_pressed("pause"):
        toggle_pause()
    if event.is_action_just_pressed("fullscreen"):
        toggle_fullscreen()

func handle_gameplay_actions(event):
    if event.is_action_just_pressed("interact"):
        player.interact()
```

Cette approche structure permet de maintenir un code propre et organisé pour la gestion des inputs complexes.