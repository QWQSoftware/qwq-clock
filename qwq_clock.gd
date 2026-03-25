extends Control
class_name QWQClock

@export var minute_label: Label
@export var second_label: Label
@export var millisecond_label: Label
@export var minute_edit: LineEdit
@export var second_edit: LineEdit
@export var millisecond_edit: LineEdit

signal time_manually_updated(new_timestamp_ms: int)
signal minute_manually_updated(new_minute: int)
signal second_manually_updated(new_second: int)
signal millisecond_manually_updated(new_millisecond: int)

var _timestamp_ms: int = 0

var minute: int:
	get:
		return _timestamp_ms / 60000
	set(value):
		if minute_label != null:
			minute_label.text = str(value)
		_timestamp_ms = value * 60000 + second * 1000 + millisecond

var second: int:
	get:
		return (_timestamp_ms / 1000) % 60
	set(value):
		value = clampi(value, 0, 59)
		if second_label != null:
			second_label.text = "%02d" % value
		_timestamp_ms = minute * 60000 + value * 1000 + millisecond

var millisecond: int:
	get:
		return _timestamp_ms % 1000
	set(value):
		value = clampi(value, 0, 999)
		if millisecond_label != null:
			millisecond_label.text = "%03d" % value
		_timestamp_ms = minute * 60000 + second * 1000 + value

func set_time(timestamp_ms: int) -> void:
	minute = timestamp_ms / 60000
	second = (timestamp_ms / 1000) % 60
	millisecond = timestamp_ms % 1000

func get_time_ms() -> int:
	return _timestamp_ms

func _ready() -> void:
	millisecond_manually_updated.connect(func(_new_value: int) -> void:
		time_manually_updated.emit(_timestamp_ms)
	)

	second_manually_updated.connect(func(_new_value: int) -> void:
		time_manually_updated.emit(_timestamp_ms)
	)

	minute_manually_updated.connect(func(_new_value: int) -> void:
		time_manually_updated.emit(_timestamp_ms)
	)
	
	minute_edit.focus_exited.connect(finish_minute_edit)
	minute_edit.text_submitted.connect(finish_minute_edit)
	
	second_edit.focus_exited.connect(finish_second_edit)
	second_edit.text_submitted.connect(finish_second_edit)
	
	millisecond_edit.focus_exited.connect(finish_millisecond_edit)
	millisecond_edit.text_submitted.connect(finish_millisecond_edit)
	
	minute_label.gui_input.connect(func(event) -> void:
		detect_input_and_modify(event, minute_label, minute_edit)
	)
	
	second_label.gui_input.connect(func(event) -> void:
		detect_input_and_modify(event, second_label, second_edit)
	)
	
	millisecond_label.gui_input.connect(func(event) -> void:
		detect_input_and_modify(event, millisecond_label, millisecond_edit)
	)
	

func finish_minute_edit(text = null) -> void:
	minute = minute_edit.text.to_int()
	minute_edit.visible = false
	minute_label.visible = true
	
	minute_manually_updated.emit(minute)

func finish_second_edit(text = null) -> void:
	second = second_edit.text.to_int()
	second_edit.visible = false
	second_label.visible = true
	
	second_manually_updated.emit(second)

func finish_millisecond_edit(text = null) -> void:
	millisecond = millisecond_edit.text.to_int()
	millisecond_edit.visible = false
	millisecond_label.visible = true
	
	millisecond_manually_updated.emit(millisecond)
	
func detect_input_and_modify(event, label, edit):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		edit.text = label.text
		label.visible = false
		edit.visible = true
		edit.grab_focus()
		edit.select_all()
