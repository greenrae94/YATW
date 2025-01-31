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
	var random_hit_chance = randf()
	var current_hit_chance = $"..".hit_chance * ($"..".enemies / 2)
	
	if ($"..".active_bleed == true):
		$"..".increaseBloodLost()
		
	$"..".increasePhysicalStress(1)
	
	if (random_chance < $"..".enemy_spawn_chance): 
		#print('increasing enemy')
		$"..".enemies += 1
		$"..".increaseHeartRate(randi() % 6)
		$"..".increaseBloodPressure(randi() % 6, randi() % 4)
		$"..".increaseMentalStress((5+$"..".enemies))
		
	elif (random_chance < $"..".enemy_spawn_chance+$"..".kill_chance):
		if ($"..".enemies - $"..".kill_potential < 0):
			$"..".enemies = 0
		else:
			$"..".enemies -= $"..".kill_potential	
		
		$"..".increaseHeartRate(randi() % (6 * $"..".kill_potential))
		$"..".increaseBloodPressure(randi() % 6, randi() % 4)
		$"..".increaseMentalStress(-5)
	if ($"..".heart_rate > $"..".resting_heart_rate):
		$"..".increaseHeartRate(-1)
		
	if ($"..".blood_pressure_systolic > $"..".resting_blood_pressure_systolic && $"..".blood_pressure_diastolic > $"..".resting_blood_pressure_diastolic):
		$"..".increaseBloodPressure(-1, -1)
	elif ($"..".blood_pressure_systolic > $"..".resting_blood_pressure_systolic):
		$"..".increaseBloodPressure(-1, 0)
	elif ($"..".blood_pressure_diastolic > $"..".resting_blood_pressure_diastolic):
		$"..".increaseBloodPressure(0, -1)
		
	if (random_hit_chance < current_hit_chance):
		$"..".determine_hit_location()
	#print('one second has passed')
	
