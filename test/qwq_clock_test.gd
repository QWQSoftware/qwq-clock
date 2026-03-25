extends Node2D

@export var timer: QWQClock
@export var start_button: Button
@export var stop_button: Button
@export var reset_button: Button

var timestamp_ms: int = 0
var ticking: bool = false

func _ready() -> void:
	ticking = false
	stop_button.disabled = true
	timestamp_ms = 0
	
	start_button.pressed.connect(func() -> void:
		ticking = true
		stop_button.disabled = false
	)
	
	stop_button.pressed.connect(func() -> void:
		ticking = false
		stop_button.disabled = true
	)
	
	reset_button.pressed.connect(func() -> void:
		timestamp_ms = 0
	)
	
	timer.time_manually_updated.connect(func(new_time) -> void:
		timestamp_ms = new_time
	)

func _process(delta: float) -> void:
	if ticking:
		timestamp_ms += delta * 1000
	
	timer.set_time(timestamp_ms)
