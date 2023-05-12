extends AnimatedSprite2D


# 05 Shooting varialbes
@export var cooldown = 0.25
@export var bullet_scene : PackedScene
var can_shoot = true

# 03 Coding the Player variables
@export var speed = 150
@onready var screensize = get_viewport_rect().size
# Called when the node enters the scene tree for the first time.
func _ready():
	start()
	self.position = Vector2(screensize.x / 2, screensize.y - 32);

func start():
	position = Vector2(screensize.x / 2, screensize.y - 64)
	$GunCooldown.wait_time = cooldown


func shoot():
	if not can_shoot:
		return
	can_shoot = false
	$GunCooldown.start()
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b) # ship 위에 붙였기 때문에, bullet이 상속되지 않아!
	b.start(position + Vector2(0, -8))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input = Input.get_vector("left", "right", "up", "down")
	
	if input.x > 0:
		self.frame = 2
		$Booster.animation = "right"
	elif input.x < 0:
		self.frame = 0
		$Booster.animation = "left"
	else:
		self.frame = 1
		$Booster.animation = "forward"
		
	self.position += input * speed * delta
	self.position = position.clamp(Vector2(8,8), screensize - Vector2(8,8))
	
	# shooting the Bullet
	if Input.is_action_pressed("shoot"):
		shoot()



func _on_gun_cooldown_timeout():
	can_shoot = true
