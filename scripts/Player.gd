extends Node
class_name Player

# ---------------------------------------------------------
# PLAYER STATS (Base + Modifiers)
# ---------------------------------------------------------

@export var max_health: int = 50
@export var damage: int = 5
@export var fire_power: int = 0
@export var ice_power: int = 0
@export var poison_power: int = 0
@export var electric_power: int = 0
@export var heal_power: int = 0

@export var dodge_chance: float = 0.0   # 0–0.50
@export var crit_chance: float = 0.0    # 0–0.40
@export var crit_damage: float = 1.5    # multiplier
@export var luck: float = 0.0           # 0–0.70
@export var shield: int = 0             # max 3?

# Runtime values
var current_health: int
var energy: int = 3
var max_energy: int = 3

# ---------------------------------------------------------
# STATUS EFFECTS
# ---------------------------------------------------------

var status_effects := {
	"burn": 0,
	"heal": 0,
	"block": 0,
	"drained": 0,
	"freeze": 0,
	"poison": 0,
	"shock": 0,
	"stun": 0
}

# ---------------------------------------------------------
# SIGNALS
# ---------------------------------------------------------

signal health_changed(new_value)
signal died
signal status_applied(name, stacks)
signal status_expired(name)

# ---------------------------------------------------------
# INITIALIZATION
# ---------------------------------------------------------

func _ready():
	current_health = max_health


# ---------------------------------------------------------
# COMBAT INTERFACE
# ---------------------------------------------------------

func start_turn():
	# Apply start-of-turn effects
	_apply_heal()
	_apply_shock()

	# Reset block each turn
	status_effects["block"] = 0

	# Draw cards handled by CombatManager
	# Energy reset
	energy = max_energy


func end_turn():
	_apply_burn()
	_apply_poison()


# ---------------------------------------------------------
# DAMAGE & DEFENSE
# ---------------------------------------------------------

func take_damage(amount: int):
	var dmg = amount

	# Freeze reduces outgoing damage, not incoming
	# Poison increases incoming damage
	if status_effects["poison"] > 0:
		dmg = int(dmg * 1.5)

	# Block reduces damage
	if status_effects["block"] > 0:
		var block_amt = status_effects["block"]
		var reduced = min(block_amt, dmg)
		dmg -= reduced
		status_effects["block"] -= reduced

	current_health -= dmg
	emit_signal("health_changed", current_health)

	if current_health <= 0:
		_die()


func deal_damage(base_amount: int, element: String = "") -> int:
	var dmg = base_amount + damage

	# Elemental bonuses
	match element:
		"fire": dmg += fire_power
		"ice": dmg += ice_power
		"poison": dmg += poison_power
		"electric": dmg += electric_power

	# Freeze reduces outgoing damage
	if status_effects["freeze"] > 0:
		dmg = int(dmg * 0.5)

	# Crit check
	if randf() < crit_chance:
		dmg = int(dmg * crit_damage)

	return dmg


# ---------------------------------------------------------
# STATUS EFFECT MANAGEMENT
# ---------------------------------------------------------

func apply_status(name: String, stacks: int = 1):
	if not status_effects.has(name):
		return

	status_effects[name] += stacks
	emit_signal("status_applied", name, status_effects[name])


func clear_status(name: String):
	if status_effects[name] > 0:
		status_effects[name] = 0
		emit_signal("status_expired", name)


# ---------------------------------------------------------
# STATUS EFFECT LOGIC
# ---------------------------------------------------------

func _apply_burn():
	if status_effects["burn"] > 0:
		take_damage(status_effects["burn"])


func _apply_heal():
	if status_effects["heal"] > 0:
		current_health = min(max_health, current_health + status_effects["heal"])
		emit_signal("health_changed", current_health)


func _apply_poison():
	if status_effects["poison"] > 0:
		take_damage(status_effects["poison"])


func _apply_shock():
	if status_effects["shock"] > 0:
		# Shock reduces energy
		energy = max(0, energy - status_effects["shock"])


# ---------------------------------------------------------
# UTILITY
# ---------------------------------------------------------

func is_stunned() -> bool:
	return status_effects["stun"] > 0


func try_dodge() -> bool:
	return randf() < dodge_chance


func _die():
	emit_signal("died")
