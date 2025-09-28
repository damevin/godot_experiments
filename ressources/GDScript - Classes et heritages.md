## Classes de base

### Créer une classe

```gdscript
# Character.gd
class_name Character
extends Node

@export var profession: String
@export var health: int

func die():
    health = 0
    print(profession + " died.")
```

### Utiliser la classe

```gdscript
# Main.gd
extends Node

@export var character_to_kill: Character

func _ready():
    character_to_kill.die()
```

**Points clés :**

- `class_name Character` : Crée un type réutilisable
- `@export var character_to_kill: Character` : Variable typée dans l'éditeur
- La classe peut être assignée dans l'inspecteur

## Inner Classes (Classes imbriquées)

```gdscript
# Character.gd
class_name Character
extends Node

var chest := Equipment.new()
var legs := Equipment.new()

func _ready():
    chest.armor = 20
    legs.weight = 10
    print(legs.weight)  # 10

class Equipment:
    var armor := 10 
    var weight := 5
```

**Utilité des inner classes :**

- Organiser le code dans une même classe
- Classes helper qui ne servent qu'à cette classe parent
- Éviter de créer plein de petits fichiers

## Héritage (Inheritance)

L'héritage permet de créer des classes qui "héritent" des propriétés et méthodes d'une classe parent.

### Classe parent (base)

```gdscript
# Character.gd
class_name Character
extends Node

@export var health := 100
@export var name: String

func take_damage(damage: int):
    health -= damage
    print("%s takes %d damage" % [name, damage])
    
    if health <= 0:
        die()

func die():
    print("%s died!" % name)
```

### Classes enfants (héritent de Character)

```gdscript
# Warrior.gd
class_name Warrior
extends Character  # Hérite de Character

@export var armor := 20

func take_damage(damage: int):
    # Override : modifie le comportement du parent
    var reduced_damage = max(1, damage - armor)
    super.take_damage(reduced_damage)  # Appelle la méthode du parent

func charge_attack():
    # Nouvelle méthode spécifique au Warrior
    print("%s charges forward!" % name)
```

```gdscript
# Mage.gd  
class_name Mage
extends Character  # Hérite de Character

@export var mana := 50

func cast_spell(spell_name: String):
    if mana >= 10:
        mana -= 10
        print("%s casts %s!" % [name, spell_name])
    else:
        print("%s has no mana!" % name)

func die():
    # Override complet
    print("%s vanishes in a puff of smoke..." % name)
    # Ne pas appeler super.die() = comportement complètement différent
```

## Utilisation de l'héritage

```gdscript
# Game.gd
extends Node

func _ready():
    # Créer différents types de personnages
    var warrior = Warrior.new()
    warrior.name = "Conan"
    warrior.health = 150
    warrior.armor = 25
    
    var mage = Mage.new()
    mage.name = "Gandalf"
    mage.health = 80
    mage.mana = 100
    
    # Utiliser les méthodes héritées
    warrior.take_damage(30)  # Réduit par l'armor
    mage.take_damage(30)     # Dégâts normaux
    
    # Utiliser les méthodes spécifiques
    warrior.charge_attack()
    mage.cast_spell("Fireball")
```

## Concepts clés de l'héritage

### `super` - Appeler la méthode du parent

```gdscript
class_name Boss
extends Character

func die():
    print("Boss is dying...")
    super.die()  # Appelle Character.die()
    print("Boss dropped rare loot!")
```

### `override` - Remplacer une méthode

```gdscript
# Sans super = remplacement complet
func take_damage(damage: int):
    print("Boss is immune to damage!")
    # Ne fait rien d'autre
```

### Polymorphisme - Traiter différents types pareil

```gdscript
func damage_all_characters(characters: Array[Character], damage: int):
    for character in characters:
        character.take_damage(damage)  # Fonctionne pour Warrior, Mage, etc.
```

## Exemple complet : Système de combat

```gdscript
# Character.gd (Base)
class_name Character
extends Node

@export var health := 100
@export var name: String

signal died(character)

func take_damage(damage: int):
    health -= damage
    if health <= 0:
        die()

func die():
    print("%s died!" % name)
    died.emit(self)

# Tank.gd
class_name Tank  
extends Character

@export var defense := 15

func take_damage(damage: int):
    var reduced = max(1, damage - defense)
    super.take_damage(reduced)
    print("%s blocks %d damage!" % [name, damage - reduced])

# Healer.gd
class_name Healer
extends Character

func heal(target: Character, amount: int):
    target.health += amount
    print("%s heals %s for %d" % [name, target.name, amount])
```

## Bonnes pratiques

**✅ À faire :**

- Hériter quand il y a une vraie relation "est un" (Warrior EST UN Character)
- Utiliser `super` pour étendre le comportement du parent
- Garder les classes parent génériques et flexibles

**❌ À éviter :**

- Héritage trop profond (> 3-4 niveaux)
- Hériter juste pour réutiliser du code (préférer la composition)
- Classes parent qui dépendent des classes enfants

## Composition vs Héritage

```gdscript
# Héritage : "EST UN"
class_name Warrior extends Character  # Un Warrior EST UN Character

# Composition : "A UN" 
class_name Character:
    var weapon: Weapon  # Un Character A UNE Weapon
    var inventory: Inventory  # Un Character A UN Inventory
```

L'héritage crée une hiérarchie de types, la composition assemble des fonctionnalités.