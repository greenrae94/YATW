extends Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(self.wait_time)
	pass

func _on_timer_timeout():
	
	if (randf() > 0.5): # 50% chance per second
		print('increasing enemy')
		$"..".enemies += 1
	print('one second has passed')
