extends GridContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _on_stimulant_pressed() -> void:
	if ($Stimulant/stim_timer.time_left == 0):
		$"../../Chat_Log/RichTextLabel".text+= '\nStimulant taken.'
		$"../../../../../..".increaseHeartRate(20)
		$"../../../../../..".increaseBloodPressure(12, 8)
		$"../../../../../..".increaseMentalStress(10)
		$"../../../../../..".increasePhysicalStress(-20)
		$"../../../../../..".increaseKillChance("Feeling Pressured")
		$Stimulant.modulate.a = 0.5
		$Stimulant/stim_timer.start()
	else:
		$"../../Chat_Log/RichTextLabel".text+= '\nStimulant is still in cooldown.'


func _on_calmudan_pressed() -> void:
	if ($Calmudan/calmudan_timer.time_left == 0): 
		$"../../Chat_Log/RichTextLabel".text+= '\nCalmudan taken.'
		$"../../../../../..".increaseMentalStress(-30)
		$"../../../../../..".increaseHeartRate(-20)
		$"../../../../../..".increaseBloodPressure(-6, -4)
		$"../../../../../..".increaseKillChance("Calm")
		$Calmudan.modulate.a = 0.5
		$Calmudan/calmudan_timer.start()
	else:
		$"../../Chat_Log/RichTextLabel".text+= '\nCalmudan is still in cooldown.'


func _on_blood_transfusion_pressed() -> void:
	if ($"Blood Transfusion/blood_transfusion_timer".time_left == 0):
		$"../../Chat_Log/RichTextLabel".text+= '\nBlood transfusion taken.'
		if ($"../../../../../..".blood_pressure_diastolic > $"../../../../../..".resting_blood_pressure_diastolic || $"../../../../../..".blood_pressure_systolic > $"../../../../../..".resting_blood_pressure_systolic):
			$"../../../../../..".increaseBloodPressure(-12,-8)
		elif ($"../../../../../..".blood_pressure_diastolic < $"../../../../../..".resting_blood_pressure_diastolic || $"../../../../../..".blood_pressure_systolic < $"../../../../../..".resting_blood_pressure_systolic):
			$"../../../../../..".increaseBloodPressure(12,8)
		if ($"../../../../../..".heart_rate > $"../../../../../..".resting_heart_rate):
			$"../../../../../..".increaseHeartRate(-15)
		elif ($"../../../../../..".heart_rate < $"../../../../../..".resting_heart_rate):
			$"../../../../../..".increaseHeartRate(15)
		
		if ($"../../../../../..".blood_lost - 0.5 < 0):
			$"../../../../../..".blood_lost = 0
			$"../../../../../..".updateBloodLost()
		else:
			$"../../../../../..".blood_lost -= 0.5
			$"../../../../../..".updateBloodLost()
		
		$"../../../../../..".increasePhysicalStress(-10)

		$"Blood Transfusion".modulate.a = 0.5
		$"Blood Transfusion/blood_transfusion_timer".start()
	else:
		$"../../Chat_Log/RichTextLabel".text+= '\nBlood transfusion is still in cooldown.'

func _on_bleed_negative_pressed() -> void:
	if ($"B(leed) Negative/bleed_negative_timer".time_left == 0):
		$"../../Chat_Log/RichTextLabel".text+= '\nB(leed) Negative taken.'
		$"../../../../../..".active_bleed = false
		$"B(leed) Negative".modulate.a = 0.5
		$"B(leed) Negative/bleed_negative_timer".start()
	else:
		$"../../Chat_Log/RichTextLabel".text+= '\nB(leed) Negative is still in cooldown.'

func _on_stim_timer_timeout() -> void:
	$"../../Chat_Log/RichTextLabel".text+= '\nStimulant cooldown has ended.'
	$Stimulant.modulate.a = 1
	$"../../../../../..".increaseHeartRate(-20)
	$"../../../../../..".increaseBloodPressure(-12, -8)
	$"../../../../../..".increaseMentalStress(-5)
	$"../../../../../..".increaseKillChance("Calm")

func _on_calmudan_timer_timeout() -> void:
	$"../../Chat_Log/RichTextLabel".text+= '\nCalmudan cooldown has ended.'
	$Calmudan.modulate.a = 1
	$"../../../../../..".increaseHeartRate(10)
	$"../../../../../..".increaseBloodPressure(6, 4)
	$"../../../../../..".increaseMentalStress(10)
	$"../../../../../..".increaseKillChance("Calm")

func _on_blood_transfusion_timer_timeout() -> void:
	$"../../Chat_Log/RichTextLabel".text+= '\nBlood transfusion cooldown has ended.'
	$"Blood Transfusion".modulate.a = 1
	$"../../../../../..".increasePhysicalStress(5)

func _on_bleed_negative_timer_timeout() -> void:
	$"../../Chat_Log/RichTextLabel".text+= '\nB(leed) Negative cooldown has ended.'
	$"B(leed) Negative".modulate.a = 1
