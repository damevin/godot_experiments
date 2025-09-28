## Concept de base

Les dictionaries sont comme des objects en JavaScript - ils stockent des paires **clé : valeur**.

```gdscript
func _ready():
    var players = {
        "Crook": 1, 
        "Villain": 30,
        "Boss": 100
    }
    
    print(players["Villain"])  # 30 (niveau du Villain)
    players["Villain"] = 50    # Modification du niveau
    print(players["Villain"])  # 50
```

## Accès et modification

### Lecture de valeurs

```gdscript
var player_data = {"name": "Hero", "level": 25, "gold": 150}

print(player_data["name"])   # "Hero"
print(player_data["level"]) # 25
```

### Modification et ajout

```gdscript
var player_data = {"name": "Hero", "level": 25}

# Modifier une valeur existante
player_data["level"] = 26

# Ajouter une nouvelle clé
player_data["gold"] = 200

print(player_data)  # {"name": "Hero", "level": 26, "gold": 200}
```

## Dictionaries complexes (imbriqués)

```gdscript
func _ready():
    var players = {
        "Crook":  {"level": 1, "health": 80},
        "Villain":  {"level": 50, "health": 120},
        "Boss":  {"level": 100, "health": 500}
    }
    
    # Accès à une valeur imbriquée
    print(players["Villain"]["health"])  # 120
    
    # Modification d'une valeur imbriquée
    players["Boss"]["health"] = 450
    
    # Afficher toutes les infos d'un joueur
    print(players["Villain"])  # {"level": 50, "health": 120}
```

## Méthodes utiles

### Vérifications et informations

```gdscript
var player = {"name": "Link", "weapon": "sword"}

print(player.size())           # 2 (nombre de clés)
print(player.has("weapon"))    # true
print(player.is_empty())       # false
print(player.keys())           # ["name", "weapon"]
print(player.values())         # ["Link", "sword"]
```

### Suppression

```gdscript
var player = {"name": "Link", "weapon": "sword", "shield": "wooden"}

player.erase("shield")         # Supprime la clé "shield"
print(player)                  # {"name": "Link", "weapon": "sword"}
```

## Itération sur les dictionaries

### Sur les clés

```gdscript
var stats = {"health": 100, "mana": 50, "strength": 15}

for stat_name in stats:
    print("%s: %d" % [stat_name, stats[stat_name]])
# Affiche : health: 100, mana: 50, strength: 15
```

### Avec keys() et values()

```gdscript
var inventory = {"potions": 5, "arrows": 20, "gold": 150}

# Itération explicite sur les clés
for key in inventory.keys():
    print("Item: %s" % key)

# Itération sur les valeurs seulement
for value in inventory.values():
    print("Quantity: %d" % value)
```

## Exemple pratique : Système de stats

```gdscript
extends CharacterBody2D

var player_stats = {
    "name": "Hero",
    "level": 1,
    "health": 100,
    "max_health": 100,
    "mana": 50,
    "max_mana": 50,
    "experience": 0
}

func _ready():
    display_stats()
    take_damage(25)
    level_up()

func display_stats():
    print("=== %s (Level %d) ===" % [player_stats["name"], player_stats["level"]])
    print("Health: %d/%d" % [player_stats["health"], player_stats["max_health"]])
    print("Mana: %d/%d" % [player_stats["mana"], player_stats["max_mana"]])
    print("Experience: %d" % player_stats["experience"])

func take_damage(damage: int):
    player_stats["health"] -= damage
    if player_stats["health"] < 0:
        player_stats["health"] = 0
    
    print("Took %d damage! Health: %d" % [damage, player_stats["health"]])

func level_up():
    player_stats["level"] += 1
    player_stats["max_health"] += 20
    player_stats["max_mana"] += 10
    player_stats["health"] = player_stats["max_health"]  # Heal complet
    player_stats["mana"] = player_stats["max_mana"]
    
    print("LEVEL UP! Now level %d" % player_stats["level"])
```

## Dictionaries vs Arrays

**Utilise Dictionary quand :**

- Tu as besoin de clés personnalisées ("nom", "level")
- L'ordre n'est pas important
- Tu veux accéder rapidement à une valeur spécifique

**Utilise Array quand :**

- L'ordre des éléments compte
- Tu veux itérer dans un ordre précis
- Tu travailles avec des indices numériques

## Vérification sécurisée

```gdscript
var player = {"name": "Hero"}

# ❌ Dangereux
print(player["level"])  # ERREUR ! La clé n'existe pas

# ✅ Sécurisé
if player.has("level"):
    print("Level: %d" % player["level"])
else:
    print("Level not set")

# ✅ Ou avec une valeur par défaut
var level = player.get("level", 1)  # Retourne 1 si "level" n'existe pas
print("Level: %d" % level)
```

## Bonnes pratiques

**✅ À faire :**

- Utiliser des noms de clés clairs et cohérents
- Vérifier l'existence des clés avec `has()` ou `get()`
- Organiser les données complexes de façon logique

**❌ À éviter :**

- Accéder à des clés sans vérifier qu'elles existent
- Mélanger les types de données sans cohérence
- Créer des structures trop profondes (difficiles à maintenir)