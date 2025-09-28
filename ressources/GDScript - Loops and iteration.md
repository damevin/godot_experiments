## Boucle For avec Arrays

```gdscript
func _ready():
    var inventory_items: Array[String] = ["Potion", "Feather", "Stolen harp"]
    for inventory_item in inventory_items:
        print(inventory_item)
    # Affiche chaque item de l'inventaire
```

**Points clés :**

- Itère sur chaque élément de l'array
- `Array[String]` force tous les éléments à être des chaînes
- Variable `inventory_item` contient l'élément actuel

## Boucle For avec range

```gdscript
func _ready():
    for n in 8:
        print(n)  # Affiche : 0, 1, 2, 3, 4, 5, 6, 7
```

**Variations utiles :**

```gdscript
for i in range(2, 10, 2):  # De 2 à 10, par pas de 2
    print(i)  # Affiche : 2, 4, 6, 8

for i in range(5, 0, -1):  # Compte à rebours
    print(i)  # Affiche : 5, 4, 3, 2, 1
```

## Boucle While

```gdscript
func _ready():
    var glass := 0.0
    while glass < 0.5:
        glass += randf_range(0.01, 0.2)
        print(glass)
    print("The glass is now half full")
```

**Important :** Toujours s'assurer que la condition peut devenir `false` pour éviter une boucle infinie !

## String Formatting (les %d et %s)

C'est une façon d'insérer des valeurs dans des chaînes de caractères :

```gdscript
var name = "Link"
var health = 100

# %s = string (texte)
# %d = decimal (nombre entier)
# %f = float (nombre décimal)

print("Player: %s has %d health" % [name, health])
# Affiche : "Player: Link has 100 health"

print("Glass level: %.2f" % glass)  # .2f = 2 décimales
# Affiche : "Glass level: 0.35"
```

## Contrôle de boucles

### Break (sortir de la boucle)

```gdscript
for item in inventory:
    if item == "Key":
        print("Found the key!")
        break  # Sort de la boucle immédiatement
    print("Still searching...")
```

### Continue (passer au suivant)

```gdscript
for item in inventory:
    if item == "":
        continue  # Ignore les items vides, passe au suivant
    print("Processing: %s" % item)
```

## Exemple pratique : Dégâts sur plusieurs ennemis

```gdscript
func attack_enemies():
    var enemies = ["Goblin", "Orc", "Skeleton"]
    var damage = 25
    
    for enemy in enemies:
        print("%s takes %d damage!" % [enemy, damage])
        # Logique de dégâts ici
```

## Bonnes pratiques

**✅ À faire :**

- Utiliser `for` pour les collections, `while` pour les conditions
- Noms de variables clairs (`enemy` plutôt que `e`)
- Éviter les boucles infinies avec `while`

**❌ À éviter :**

- Modifier un array pendant qu'on l'itère
- Boucles `while` sans condition de sortie claire