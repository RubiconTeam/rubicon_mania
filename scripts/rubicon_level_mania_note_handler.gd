@tool
class_name RubiconLevelManiaNoteHandler extends RubiconLevelNoteHandler

enum LaneState {
	LANE_STATE_NEUTRAL = 0,
	LANE_STATE_PUSH = 1,
	LANE_STATE_HIT = 2
}

@export var global_direction : float = 0.0

@export_group("Lane", "lane_")
@export var lane_id : int = 0
@export var lane_state : LaneState = LaneState.LANE_STATE_NEUTRAL

## The currently held note, if any.
var held_note : int = -1

func _init() -> void:
	settings = load("res://addons/rubicon_mania/resources/default_settings.tres")

func _property_get_revert(property : StringName) -> Variant:
	if property == "settings" and ResourceLoader.exists("res://addons/rubicon_mania/resources/default_settings.tres"):
		return load("res://addons/rubicon_mania/resources/default_settings.tres")
	
	return super(property)

func _process(delta: float) -> void:
	super(delta)
	if not _should_process():
		return

func sort_graphic(data_index : int) -> void:
	var graphic : RubiconLevelNote = graphics[data_index]
	
	# Easy sorting
	if data_index > 0 and graphics[data_index - 1] != null: # Get the note behind
		move_child(graphic, graphics[data_index - 1].get_index() + 1)
		return
	
	if graphics[data_index + 1] != null: # Get the note in front
		move_child(graphic, graphics[data_index + 1].get_index())
		return
	
	var target_index : int = -1
	for i in graphics.size():
		var current : RubiconLevelNote = graphics[i]
		if current != null:
			if i < data_index:
				target_index = current.get_index() + 1
			else:
				target_index = current.get_index()
			
			break
	
	move_child(graphic, target_index)

func get_mode_id() -> StringName:
	return "mania"

func get_unique_id() -> StringName:
	return "mania_lane%s" % lane_id 
