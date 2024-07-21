extends Camera3D

var distance : int = 0

func _ready() -> void:
	distance = position.length()

func _process(delta: float) -> void:
	var factor = fmod(Time.get_ticks_msec() / 1000.0, 2 * PI)
	position = Vector3(distance * sin(factor), position.y, distance * cos(factor))

	look_at(Vector3(0,position.y,0), Vector3(0,1,0))
