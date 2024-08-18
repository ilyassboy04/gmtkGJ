extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


@onready var light_occluder = $Player/LightOccluder2D
@onready var shadow_body = $StaticBody2D2
@onready var point_light = $StaticBody2D/PointLight2D

var shadow_locked = false
var shadow_polygon

func _process(delta):
	# AcTivate Shadow = 1;
	# Remove Shadow = 2;
	
	if Input.is_action_just_pressed("Activate Shadow"):
		if not shadow_locked:
			shadow_locked = true
			draw_shadow()
			print("Shadow is placed")
	
	if Input.is_action_just_pressed("Remove Shadow"):
		shadow_locked = false;
		#draw_shadow()
		print("Shadow is removed")
		
	if not shadow_locked:
		update_shadow_body()

func update_shadow_body():
	var light_pos = point_light.global_position
	
	# TODO: prøv å endre til noe annet, litt forvirrende
	# https://docs.godotengine.org/en/stable/classes/class_packedvector2array.html
	shadow_polygon = PackedVector2Array()
	var occluder_points = light_occluder.occluder.polygon
	
	# For hvert punkt i Light Occluder på Spillern
	for point in occluder_points:
		var global_point = light_occluder.to_global(point)
		var direction = (global_point - light_pos).normalized()
		
		# Shadow Lengde, 1000 kan endres til en hver verdi
		# TODO: Finn lengde som matcher, må fikses etter at shadow er visible
		var shadow_point = global_point + direction * 1000
		shadow_polygon.append(global_point)
		shadow_polygon.append(shadow_point)
	
	# Lager Collision shape basert på shadowen
	var collision_polygon = CollisionPolygon2D.new()
	collision_polygon.polygon = shadow_polygon
	
	# Adder Collision shape hvis shadowen ikke har det
	if shadow_body.get_child_count() == 0:
		shadow_body.add_child(collision_polygon)
	else:
		# Oppdatered colision shapoe for shadow
		var existing_collision_polygon = shadow_body.get_child(0)
		existing_collision_polygon.polygon = shadow_polygon
	

func draw_shadow():
	if(shadow_locked):
		var polygon_visual = shadow_body.get_node_or_null("PolygonVisual") as Polygon2D
		if polygon_visual == null:
			polygon_visual = Polygon2D.new()
			polygon_visual.name = "polygon_visual"
			shadow_body.add_child(polygon_visual)
	
		polygon_visual.polygon = shadow_polygon
		polygon_visual.color = Color.BLACK
	
	# TODO: må fjerne den når jeg trykker 2, den må kunne bli tegnet flere ganger

 
