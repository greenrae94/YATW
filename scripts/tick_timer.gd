extends Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_timer_timeout():
	var random_chance = randf()
	var random_hit_chance = randf()
	var current_hit_chance = $"..".hit_chance * ($"..".enemies / 2)
	
	
	if ($"..".active_bleed == true):
		$"..".increaseBloodLost()
		
	
	$"..".increasePhysicalStress(1)
	
	# Enemy spawn
	if (random_chance < $"..".enemy_spawn_chance): 
		$"..".enemies += 1
		$"../Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Chat_Log/RichTextLabel".text += "\nEnemy spawned"
		$"..".increaseHeartRate(randi() % 6)
		$"..".increaseBloodPressure(randi() % 6, randi() % 4)
		$"..".increaseMentalStress((5+$"..".enemies))

		# Enemy kill
	elif (random_chance < $"..".enemy_spawn_chance+$"..".kill_chance):
		var enemies_killed = randi() % $"..".kill_potential + 1
		if ($"..".enemies - enemies_killed < 0):
			$"..".enemies = 0
			$"../Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Chat_Log/RichTextLabel".text += "\n" + str($"..".enemies) + " enemies killed."

		else:
			$"..".enemies -= enemies_killed
			$"../Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Chat_Log/RichTextLabel".text += "\n" + str(enemies_killed) + " enemies killed."

		
		$"..".increaseHeartRate(randi() % (6 * enemies_killed))
		$"..".increaseBloodPressure(randi() % 6, randi() % 4)
		$"..".increaseMentalStress(-5)
		
	# Heart rate returning to normal
	if ($"..".heart_rate > $"..".resting_heart_rate):
		$"..".increaseHeartRate(-1)
	# Blood pressure returning to normal
	if ($"..".blood_pressure_systolic > $"..".resting_blood_pressure_systolic && $"..".blood_pressure_diastolic > $"..".resting_blood_pressure_diastolic):
		$"..".increaseBloodPressure(-1, -1)
	elif ($"..".blood_pressure_systolic > $"..".resting_blood_pressure_systolic):
		$"..".increaseBloodPressure(-1, 0)
	elif ($"..".blood_pressure_diastolic > $"..".resting_blood_pressure_diastolic):
		$"..".increaseBloodPressure(0, -1)
	
	# Player hit
	if (random_hit_chance < current_hit_chance):
		$"../Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Chat_Log/RichTextLabel".text += "\nYou've taken a hit!"
		$"..".determine_hit_location()
