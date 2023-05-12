extends Area2D
@export var speed = -250

# Bullet starts position
func start(pos): 
	position = pos

# Move the Bullet itself
func _process(delta):
	position.y += speed * delta

# if the Bullet hits the enemy.
func _on_area_entered(area):
	if area.is_in_group("enemies"):
		area.explode()
		queue_free()


#The situation which bullet gets off the Screen,(disable)
func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

