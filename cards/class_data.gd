extends Resource
class_name ClassData

@export var deck_name : String

# Base Stats
@export var max_health: int = 50
@export var damage: int = 5
@export var fire_power: int = 0
@export var ice_power: int = 0
@export var poison_power: int = 0
@export var electric_power: int = 0
@export var heal_power: int = 0
@export var shield: int = 0

@export var max_energy: int = 3

# Starting Deck (10 cards)
@export var starting_deck: Array[CardData]
