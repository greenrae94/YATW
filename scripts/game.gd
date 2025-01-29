extends Node

var enemies: int = 1
var hit_chance = 0.1
var enemy_spawn_chance = 0.3
var kill_chance = 0.2
var kill_potential = 1
var base_damage = 20
var round_over = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$"Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Timer/Enemies (debug)".text = "enemies: %s" % self.enemies
	if round_over == true:
		if enemies == 0:
			game_over()
	
	
func game_over() -> void: 
	print("You fucking died dweebus")
	get_tree().change_scene_to_file("res://menu.tscn")
	
func determine_hit_location(): 
	if ($"Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Shield_Health".value != 0):
		on_hit("default", base_damage)
	elif ($"Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Suit_Health_Bar".value != 0):
		on_hit("Suit_Health_Bar",base_damage)
	else: 
		on_hit("Health_Bar", base_damage)


func on_hit(target, value) -> void:
	match target:
		"default":
			print("Me shieldies!")
			$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Shield_Health.value -= value
		"Suit_Health_Bar":
			print("Me suities!")
			$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Suit_Health_Bar.value -= value
		"Health_Bar":
			print("Me healthies!")
			$Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Health_Bar.value -= value
			if $Global_Level_Timer/Core_UI_Control/MarginContainer/Core_UI_Layout/Vitals/Health_Bar.value != 0: 
				pass
			else:
				game_over()
	


func _on_global_level_timer_timeout() -> void:
	enemy_spawn_chance = 0
	round_over = true
	
