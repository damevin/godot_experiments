## Déclaration et Types

### Array typé (recommandé)

```gdscript
func _ready():
    var inventory_items: Array[String] = ["Potion", "Feather", "Stolen harp"]
    # Tous les éléments DOIVENT être des String
```

### Array non typé (possible mais pas recommandé)

```gdscript
var mixed_array = ["Text", 42, true, Vector2(1, 2)]
# Peut contenir n'importe quoi, mais moins sûr
```

**Pourquoi préférer les arrays typés ?**

- **Sécurité** : Évite les erreurs de type
- **Performance** : Plus rapide
- **Autocomplétion** : L'éditeur aide mieux

## Manipulation de base

### Accès aux éléments

```gdscript
var items: Array[String] = ["Potion", "Feather", "Stolen harp"]

print(items[0])  # "Potion" (premier élément)
print(items[1])  # "Feather"
print(items[2])  # "Stolen harp" (dernier élément)

# Modification d'un élément
items[1] = "Smelly sock"
print(items[1])  # "Smelly sock"
```

### Ajouter des éléments

```gdscript
var items: Array[String] = ["Potion"]

items.append("Overpowered sword")        # Ajoute à la fin
items.push_front("Magic ring")           # Ajoute au début
items.insert(1, "Health potion")         # Ajoute à l'index 1

print(items)  # ["Magic ring", "Health potion", "Potion", "Overpowered sword"]
```

### Supprimer des éléments

```gdscript
var items: Array[String] = ["Potion", "Feather", "Stolen harp", "Sword"]

items.remove_at(1)              # Supprime l'index 1 ("Feather")
items.erase("Sword")            # Supprime par valeur
var last_item = items.pop_back() # Supprime et retourne le dernier
var first_item = items.pop_front() # Supprime et retourne le premier

print(items)  # ["Stolen harp"]
```

## Méthodes utiles

### Informations sur l'array

```gdscript
var items: Array[String] = ["Potion", "Sword", "Shield"]

print(items.size())           # 3 (nombre d'éléments)
print(items.is_empty())       # false
print(items.has("Sword"))     # true
print(items.find("Shield"))   # 2 (index de "Shield")
```

### Tri et recherche

```gdscript
var numbers: Array[int] = [3, 1, 4, 1, 5]
numbers.sort()                # Trie l'array
print(numbers)               # [1, 1, 3, 4, 5]

var names: Array[String] = ["Bob", "Alice", "Charlie"]
names.sort()
print(names)                 # ["Alice", "Bob", "Charlie"]
```

## Exemple pratique : Gestion d'inventaire

```gdscript
extends Node

var inventory: Array[String] = []

func _ready():
    # Ajout d'items de départ
    add_item("Health Potion")
    add_item("Rusty Sword")
    add_item("Leather Armor")
    
    display_inventory()
    
    # Utilisation d'un item
    use_item("Health Potion")
    display_inventory()

func add_item(item_name: String):
    inventory.append(item_name)
    print("Added: %s" % item_name)

func use_item(item_name: String):
    if inventory.has(item_name):
        inventory.erase(item_name)
        print("Used: %s" % item_name)
    else:
        print("Item not found: %s" % item_name)

func display_inventory():
    print("\n=== INVENTORY ===")
    if inventory.is_empty():
        print("Empty")
        return
    
    for i in inventory.size():
        print("%d. %s" % [i + 1, inventory[i]])
    print("Total items: %d" % inventory.size())
```

## Arrays 2D (pour les grilles)

```gdscript
# Création d'une grille 3x3
var grid: Array[Array] = []

func create_grid():
    for x in 3:
        var row: Array[String] = []
        for y in 3:
            row.append(".")  # Case vide
        grid.append(row)
    
    # Accès : grid[x][y]
    grid[1][1] = "X"  # Centre de la grille
    
    print_grid()

func print_grid():
    for row in grid:
        print(" ".join(row))  # Affiche la ligne
```

## Bonnes pratiques

**✅ À faire :**

- Toujours typer tes arrays : `Array[String]`
- Vérifier la taille avant d'accéder aux éléments
- Utiliser des noms descriptifs

**❌ À éviter :**

- Accéder à un index qui n'existe pas (erreur !)
- Mélanger les types sans raison
- Arrays trop grands (préférer des dictionnaires parfois)

## Vérification sécurisée

```gdscript
var items: Array[String] = ["Potion", "Sword"]

# ❌ Dangereux
print(items[5])  # ERREUR ! Index hors limites

# ✅ Sécurisé
if items.size() > 5:
    print(items[5])
else:
    print("Index trop grand
```