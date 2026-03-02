extends Resource
class_name EffectData

enum EffectType {
	DAMAGE,
	BLOCK,
	APPLY_STATUS,
	MODIFY_STAT,
	TEMP_STAT,
	MULTIPLIER_DAMAGE
}

@export var effect_type: EffectType

@export var amount : int = 0
@export var multiplier : float = 1.0
@export var hits : int = 1
@export var chance : float = 1.0

@export var stat_name : String = ""
@export var status_name : String = ""
@export var duration_turns : int = 0
