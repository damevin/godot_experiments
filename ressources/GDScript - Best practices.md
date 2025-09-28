
### Call down, Signal Up

## Principe de base

**Call Down** : Le parent appelle directement les fonctions de ses enfants **Signal Up** : L'enfant émet un signal que le parent écoute

## Call Down (Parent → Enfant)

Le parent connaît ses enfants et peut leur donner des ordres directement.

```gdscript
# Parent (GameManager)
extends Node

@onready var player = $Player
@onready var ui = $UI

func start_game():
    player.spawn_at_position(Vector2(100, 100))  # Appel direct
    ui.show_game_hud()                          # Appel direct
    
func game_over():
    player.disable_controls()                   # Appel direct
    ui.show_game_over_screen()                  # Appel direct
```

## Signal Up (Enfant → Parent)

L'enfant émet un signal, le parent écoute et réagit.

```gdscript
# Enfant (Player)
extends CharacterBody2D
signal died
signal health_changed(new_health)

func take_damage(damage):
    health -= damage
    health_changed.emit(health)  # Signal vers le parent
    
    if health <= 0:
        died.emit()              # Signal vers le parent

# Parent (GameManager)
extends Node

func _ready():
    $Player.died.connect(_on_player_died)              # Écoute
    $Player.health_changed.connect(_on_health_changed) # Écoute

func _on_player_died():
    game_over()  # Réaction au signal

func _on_health_changed(new_health):
    $UI.update_health_bar(new_health)  # Call down vers UI
```

## Pourquoi cette organisation ?

**Call Down** = Contrôle et coordination

- Le parent orchestre le jeu
- Instructions claires de haut en bas

**Signal Up** = Communication d'événements

- L'enfant informe de ce qui lui arrive
- Le parent décide quoi faire avec l'info

## Exemple complet

```gdscript
# GameManager (Parent)
extends Node

@onready var player = $Player
@onready var enemy_spawner = $EnemySpawner
@onready var ui = $UI

func _ready():
    # Signal Up : Écoute les enfants
    player.died.connect(_on_player_died)
    player.level_up.connect(_on_player_level_up)

func start_wave():
    # Call Down : Donne des ordres
    enemy_spawner.spawn_enemies(5)
    ui.show_wave_info("Wave 1")
    player.reset_position()

func _on_player_died():
    # Réaction au signal, puis Call Down
    enemy_spawner.stop_spawning()
    ui.show_game_over()

func _on_player_level_up(new_level):
    # Réaction au signal, puis Call Down  
    ui.show_level_up_effect()
    enemy_spawner.increase_difficulty()
```

**Résumé** : Les parents commandent (call down), les enfants informent (signal up).

![[CleanShot 2025-09-14 at 8 .01.19@2x.png]]