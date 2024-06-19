extends Node

class_name SpellSystem


var spell_configs = [
	preload('res://Resources/Spells/fire_spell_config.tres'),
	preload('res://Resources/Spells/ice_spell_config.tres'),
	preload('res://Resources/Spells/plant_spell_config.tres')
]



@onready var animated_sprite_2d = $"../AnimatedSprite2D"
@onready var spell_scene = preload('res://Scenes/spell.tscn')
var active_spell_idx: int
@onready var inventory = $"../Inventory" as Inventory
@onready var on_screen_ui = $"../OnScreenUI" as OnScreenUI

var current_spell_cooldown = null 
var cooldown_timer = 0;

func _ready():
	inventory.spell_activated.connect(on_spell_activated)
	
func _process(delta):
	if current_spell_cooldown != null && cooldown_timer < current_spell_cooldown:
		cooldown_timer += delta

	
func on_spell_activated(idx:int):
	active_spell_idx = idx
	var spell_config = spell_configs[active_spell_idx] as SpellConfig
	on_screen_ui.toggle_spell_slot(true, spell_config.ui_texture)

func cast_spell():
	var spell_direction =  animated_sprite_2d.attack_vector
	var spell_config = spell_configs[active_spell_idx] as SpellConfig
	current_spell_cooldown = spell_config.initial_cooldown
	
	if cooldown_timer != 0 && cooldown_timer < current_spell_cooldown:
		return 
	else:
		cooldown_timer = 0
	
	on_screen_ui.spell_cooldown_activated(current_spell_cooldown)
	var spell_rotation = get_spell_rotation(spell_direction, spell_config.initial_rotation)
	var spell = spell_scene.instantiate() as Spell
	
	get_tree().root.add_child(spell)
	spell.rotation_degrees = spell_rotation
	spell.direction = spell_direction
	spell.init(spell_config)
	spell.position = get_parent().global_position
		
func get_spell_rotation(spell_direction: Vector2, initial_rotation: int):
	match spell_direction:
		Vector2.LEFT:
			return -180 + initial_rotation
		Vector2.RIGHT: 
			return 0 + initial_rotation
		Vector2.UP: 
			return -90 + initial_rotation
		Vector2.DOWN:
			return 90 + initial_rotation




