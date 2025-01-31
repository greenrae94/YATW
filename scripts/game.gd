extends Node

var enemies: int = 1
var hit_chance = 0.1
var enemy_spawn_chance = 0.5
var kill_chance = 0.2
var base_kill_chance = 0.2
var kill_potential = 1
var base_damage = 20

var round_over = false

var max_heart_rate = randi() % 21 + 180
var min_heart_rate = 20
var heart_rate = randi() % 16 + 45
var resting_heart_rate = heart_rate

var blood_pressure_systolic = randi() % 31 + 90
var resting_blood_pressure_systolic = blood_pressure_systolic
var blood_pressure_diastolic = randi() % 21 + 60
var resting_blood_pressure_diastolic = blood_pressure_diastolic
var high_pressure_systolic = 180
var high_pressure_diastolic = 120
var low_pressure_systolic = 90

var active_bleed = false
var blood_lost = 0
var blood_loss_rate = 0.1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateHeartRate()
	updateBloodPressure()
	updateBloodLost()
	updateMentalState()
	updatePhysicalState()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$"Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Timer/Enemies (debug)".text = "enemies: %s" % self.enemies
	if round_over == true:
		if enemies == 0:
			game_over()
	
	
func game_over() -> void: 
	#print("You died dweebus")
	get_tree().change_scene_to_file("res://menu.tscn")
	
func determine_hit_location(): 
	if ($Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/VBoxContainer/CenterContainer/Shield_Health.value != 0):
		on_hit("default", base_damage)
	elif ($Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/VBoxContainer/CenterContainer2/Suit_Health_Bar.value != 0):
		on_hit("Suit_Health_Bar",base_damage)
	else: 
		on_hit("Health_Bar", base_damage)


func on_hit(target, value) -> void:
	match target:
		"default":
			#print("Me shieldies!")
			$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/VBoxContainer/CenterContainer/Shield_Health.value -= value
			checkShields()
			increaseHeartRate(randi() % 6)
			increaseBloodPressure(randi() % 6, randi() % 4)
			increaseMentalStress(5)
		"Suit_Health_Bar":
			#print("Me suities!")
			$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/VBoxContainer/CenterContainer2/Suit_Health_Bar.value -= value
			$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/VBoxContainer/CenterContainer2/Suit_Health_Bar/Label.text = "Suit @ " + str($Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/VBoxContainer/CenterContainer2/Suit_Health_Bar.value) + "%"
			increaseHeartRate(randi() % 11 + 5)
			increaseBloodPressure(randi() % 12, randi() % 8)
			increaseMentalStress(15)
		"Health_Bar":
			#print("Me healthies!")
			$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Health_Bar.value -= value
			if $Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Health_Bar.value != 0: 
				pass
			else:
				game_over()
			increaseHeartRate(randi() % 21 + 10)
			increaseBloodPressure(randi() % 30, randi() % 20)
			increaseMentalStress(25)
			checkBleed()

func updateHeartRate() -> void:
	$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Heart_Rate.text = "Heart Rate: " + str(heart_rate)
	
func updateBloodPressure() -> void: 
	$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Blood_Pressure.text = "Blood Pressure: " + str(blood_pressure_systolic) + " / " + str(blood_pressure_diastolic)
	
func updateBloodLost() -> void: 
	$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Blood_Loss.text = "Blood Lost: " + str(blood_lost) + "L"
	
func updateMentalState() -> void:
	if ($Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Mental_Stress_Bar.value > 75):
		if ($Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Mental_State.text != "Breaking Point"):
			increaseKillChance("Breaking Point")
			$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Mental_State.text = "Breaking Point"
		
	elif ($Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Mental_Stress_Bar.value > 50):
		if ($Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Mental_State.text != "Panicked"):
			increaseKillChance("Panicked")
			$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Mental_State.text = "Panicked"
		
	elif ($Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Mental_Stress_Bar.value > 25):
		if ($Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Mental_State.text != "Stressed"):
			increaseKillChance("Stressed")
			$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Mental_State.text = "Stressed"
		
	elif ($Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Mental_Stress_Bar.value > 1):
		if ($Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Mental_State.text != "Feeling Pressured"):
			increaseKillChance("Feeling Pressured")
			$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Mental_State.text = "Feeling Pressured"
		
	else:
		if ($Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Mental_State.text != "Calm"):
			increaseKillChance("Calm")
			$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Mental_State.text = "Calm"

func updatePhysicalState() -> void:
	if ($Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Physical_Stress_Bar.value > 75):
		if ($Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Physical_State.text != "Exhausted"):
			increaseKillChance("Breaking Point")
			$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Physical_State.text = "Exhausted"
		
	elif ($Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Physical_Stress_Bar.value > 50):
		if ($Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Physical_State.text != "Over-exerted"):
			increaseKillChance("Panicked")
			$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Physical_State.text = "Over-exerted"
		
	elif ($Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Physical_Stress_Bar.value > 25):
		if ($Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Physical_State.text != "Strained"):
			increaseKillChance("Stressed")
			$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Physical_State.text = "Strained"
		
	elif ($Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Physical_Stress_Bar.value > 1):
		if ($Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Physical_State.text != "Warmed Up"):
			increaseKillChance("Feeling Pressured")
			$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Physical_State.text = "Warmed Up"
		
	else:
		if ($Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Physical_State.text != "Relaxed"):
			increaseKillChance("Calm")
			$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Physical_State.text = "Relaxed"	
	
func increaseHeartRate(value) -> void: 
	heart_rate += value 
	updateHeartRate()
	if (heart_rate >= max_heart_rate):
		game_over()
	elif (heart_rate <= min_heart_rate):
		game_over()
		
func increaseBloodPressure(systolic, diastolic) -> void: 
	blood_pressure_systolic += systolic
	blood_pressure_diastolic += diastolic
	updateBloodPressure()
	if (blood_pressure_systolic < 1):
		game_over()
	if (blood_pressure_diastolic < 1):
		game_over()
	if (blood_pressure_systolic > high_pressure_systolic): 
		print("Danger, Will Robinson (Me sys bloodies)")
	if (blood_pressure_diastolic > high_pressure_diastolic): 
		print("Danger, Will Robinson (Me dia bloodies)")
	if (blood_pressure_systolic < low_pressure_systolic):
		print("Danger, Will Robinson (Me sys bloodies low)")

func increaseBloodLost() -> void: 
	blood_lost += blood_loss_rate
	updateBloodLost()
	if (blood_lost > 2):
		game_over()
	elif (blood_lost > 0.75 && blood_lost < 1.5): 
		increaseBloodPressure(-6, -4)
	elif (blood_lost > 1.5):
		increaseBloodPressure(-12, -8)

func increaseMentalStress(value) -> void: 
	$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Mental_Stress_Bar.value += value
	updateMentalState()
	
func increasePhysicalStress(value) -> void:
	$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Physical_Stress_Bar.value += value
	updatePhysicalState()
	
func increaseKillChance(condition) -> void:
	match condition:
		"Breaking Point":
			kill_chance -= (kill_chance/2)
			
		"Panicked":
			kill_chance -= (kill_chance/4)
		
		"Stressed":
			kill_chance += (kill_chance/4)
		
		"Feeling Pressured":
			kill_chance += (kill_chance/2)
			
		"Calm":
			kill_chance = base_kill_chance
	
func checkBleed() -> void: 
	if (randf() < 0.8): 
		active_bleed = true
		increaseMentalStress(25)
	
func checkShields() -> void:
	if ($Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/VBoxContainer/CenterContainer/Shield_Health.value > 75):
		$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/VBoxContainer/CenterContainer/Shield_Health/Label.text = "Shields Stable"
	elif ($Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/VBoxContainer/CenterContainer/Shield_Health.value > 50):
		$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/VBoxContainer/CenterContainer/Shield_Health/Label.text = "Shields Holding"
	elif ($Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/VBoxContainer/CenterContainer/Shield_Health.value > 25):
		$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/VBoxContainer/CenterContainer/Shield_Health/Label.text= "Shields Waning"
	elif ($Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/VBoxContainer/CenterContainer/Shield_Health.value > 1):
		$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/VBoxContainer/CenterContainer/Shield_Health/Label.text= "Shields Critical"
	else:
		$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/VBoxContainer/CenterContainer/Shield_Health/Label.text= "Shields Depleted"

func _on_global_level_timer_timeout() -> void:
	enemy_spawn_chance = 0
	round_over = true
	
