extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_boost_shields_pressed() -> void:
	$"../VBoxContainer/CenterContainer/Shield_Health".value += 1
	$"../Chat_Log/RichTextLabel".text += "\nIncreasing shields"

func _on_make_quip_pressed() -> void:
	$"../../../../..".increaseBloodPressure(-3,-2)
	$"../../../../..".increaseMentalStress(-5)
	$"../Chat_Log/RichTextLabel".text += "\nHaha, hilarious"

func _on_deploy_countermeasures_pressed() -> void:
	$"../../../../..".increaseKillChance("Feeling Pressured")
	$"../Chat_Log/RichTextLabel".text += "\nCountermeasures deployed (chance of making a kill increased)"

func _on_upgrade_weapon_pressed() -> void:
	$"../../../../..".increaseKillChance("Feeling Pressured")
	if $"../../../../..".kill_potential < 6:
		$"../../../../..".kill_potential += 1
		$"../Chat_Log/RichTextLabel".text += "\nWeapon upgraded (you can now kill up to " + str($"../../../../..".kill_potential) + " enemies in one go)"
	else:
		$"../Chat_Log/RichTextLabel".text += "\nWeapon is maxed out"
	
	
