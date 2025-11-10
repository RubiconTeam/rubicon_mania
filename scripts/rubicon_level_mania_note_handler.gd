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

func hit_note(index : int, time_when_hit : float, hit_type : RubiconLevelNoteHitResult.Hit) -> void:
	super(index, time_when_hit, hit_type)

	if hit_type == RubiconLevelNoteHitResult.Hit.HIT_INCOMPLETE:
		results[index].scoring_value = 0.25
		return
	
	match results[index].scoring_rating:
		RubiconLevelNoteHitResult.Judgment.JUDGMENT_PERFECT:
			results[index].scoring_value = 1.0
		RubiconLevelNoteHitResult.Judgment.JUDGMENT_GREAT:
			results[index].scoring_value = 0.9375
		RubiconLevelNoteHitResult.Judgment.JUDGMENT_GOOD:
			results[index].scoring_value = 0.625
		RubiconLevelNoteHitResult.Judgment.JUDGMENT_OKAY:
			results[index].scoring_value = 0.3125
		RubiconLevelNoteHitResult.Judgment.JUDGMENT_BAD:
			results[index].scoring_value = 0.9375
		RubiconLevelNoteHitResult.Judgment.JUDGMENT_MISS:
			results[index].scoring_value = 0.15625

func sort_graphic(data_index : int) -> void:
	var graphic : RubiconLevelNote = graphics[data_index]
	
	# Easy sorting
	if data_index > 0 and data_index < data.size() and graphics[data_index - 1] != null: # Get the note behind
		move_child(graphic, graphics[data_index - 1].get_index() + 1)
		return
	
	if data_index + 1 < data.size() and graphics[data_index + 1] != null: # Get the note in front
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

func _autoplay_process(millisecond_position : float) -> void:
	while data[note_hit_index].get_millisecond_start_position() - millisecond_position <= 0:
		# Hold note logic
		if data[note_hit_index].ending_row != null:
			if results[note_hit_index] == null or results[note_hit_index].scoring_hit == RubiconLevelNoteHitResult.Hit.HIT_NONE:
				hit_note(note_hit_index, data[note_hit_index].get_millisecond_start_position(), RubiconLevelNoteHitResult.Hit.HIT_INCOMPLETE)
			
			break

		hit_note(note_hit_index,data[note_hit_index].get_millisecond_end_position(), RubiconLevelNoteHitResult.Hit.HIT_COMPLETE)
		note_hit_index += 1

func _property_get_revert(property : StringName) -> Variant:
	if property == "settings" and ResourceLoader.exists("res://addons/rubicon_mania/resources/default_settings.tres"):
		return load("res://addons/rubicon_mania/resources/default_settings.tres")
	
	return super(property)