extends Area2D

var start_pos = Vector2.ZERO
var speed: float = 0
signal died


@onready var screensize = get_viewport_rect().size

func start(pos):
	speed = 0
	position = Vector2(pos.x, -pos.y)
	start_pos = pos
	# 스크립트 중지, 캐릭터가 대기
	await get_tree().create_timer(randf_range(0.25, 0.55)).timeout
	#3이라면 start()가 필요했는데 4는 create_tween()하면 자동적으로 개시되게 된 것은 처음에는 조금 이해하기 힘들었죠.
	var tween = create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "position:y", start_pos.y, 1.4)
	# 애니메이션이 완전히 끝나고 난 후에만 캐릭터가 이동하거나 총을 쏘도록 하기 위함
	await tween.finished

func _on_timer_timeout():
	speed = randf_range(75, 100)
	

func _on_shoot_timer_timeout():
	$ShootTimer.wait_time = randf_range(4, 20)
	$ShootTimer.start()

func _process(delta):
	position.y += speed * delta
	if position.y > screensize.y + 32:
		start(start_pos)

func explode():
	speed = 0
	$AnimationPlayer.play("explode")
	#현재 프레임의 충돌을 헤제해 2번 충돌하는 것을 막는다.
	set_deferred("monitoring", false)
	died.emit(5)
	await $AnimationPlayer.animation_finished
	queue_free()
