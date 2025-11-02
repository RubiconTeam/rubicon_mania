class_name RubiconLevelManiaNoteHandler extends RubiconLevelNoteHandler

enum LaneState {
	LANE_STATE_NEUTRAL = 0,
	LANE_STATE_PUSH = 1,
	LANE_STATE_HIT = 2
}

@export_group("Lane", "lane_")
@export var lane_id : int = 0
@export var lane_state : LaneState = LaneState.LANE_STATE_NEUTRAL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
