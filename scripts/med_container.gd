extends GridContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_stimulant_pressed() -> void:
	if ($Stimulant/stim_timer.time_left == 0):
		$"../../../../../..".increaseHeartRate(20)
		$"../../../../../..".increaseBloodPressure(12, 8)
		$"../../../../../..".increaseMentalStress(10)
		$"../../../../../..".increasePhysicalStress(-20)
		$"../../../../../..".increaseKillChance("Feeling Pressured")
		$Stimulant.modulate.a = 0.5
		$Stimulant/stim_timer.start()

func _on_calmudan_pressed() -> void:
	if ($Calmudan/calmudan_timer.time_left == 0): 
		$"../../../../../..".increaseMentalStress(-30)
		$"../../../../../..".increaseHeartRate(-20)
		$"../../../../../..".increaseBloodPressure(-6, -4)
		$"../../../../../..".increaseKillChance("Calm")
		$Calmudan.modulate.a = 0.5
		$Calmudan/calmudan_timer.start()

func _on_bleed_negative_pressed() -> void:
	pass # Replace with function body.


func _on_stim_timer_timeout() -> void:
	$Stimulant.modulate.a = 1
	$"../../../../../..".increaseHeartRate(-20)
	$"../../../../../..".increaseBloodPressure(-12, -8)
	$"../../../../../..".increaseMentalStress(-5)
	$"../../../../../..".increaseKillChance("Calm")


func _on_calmudan_timer_timeout() -> void:
	$Calmudan.modulate.a = 1
	$"../../../../../..".increaseHeartRate(10)
	$"../../../../../..".increaseBloodPressure(6, 4)
	$"../../../../../..".increaseMentalStress(10)
	$"../../../../../..".increaseKillChance("Calm")
