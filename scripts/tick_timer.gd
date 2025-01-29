extends Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(self.wait_time)
	pass

func _on_timer_timeout():
	var random_chance = randf()
	var current_hit_chance = $"..".hit_chance * $"..".enemies
	
	if (random_chance < $"..".enemy_spawn_chance): 
		print('increasing enemy')
		$"..".enemies += 1
	elif (random_chance < $"..".enemy_spawn_chance+$"..".kill_chance):
		if ($"..".enemies - $"..".kill_potential < 0):
			$"..".enemies = 0
		else:
			$"..".enemies -= $"..".kill_potential
		
	if (random_chance < current_hit_chance):
		$"..".determine_hit_location()
	print('one second has passed')
