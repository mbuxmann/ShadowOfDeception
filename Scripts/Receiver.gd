extends Area2D

signal destroyFireball
signal puzzleComplete

export var fireballsNeeded = 1
export(NodePath) var keyTarget0
export(NodePath) var keyTarget1
export(NodePath) var keyTarget2
export(NodePath) var keyTarget3
export(NodePath) var keyTarget4

var fireballs = 0
var Completed = false
var keyTargets = []
var keyTarget

func _ready():
	$AnimationPlayer.play('receiverIdle')
	keyTargets = [keyTarget0, keyTarget1, keyTarget2, keyTarget3, keyTarget4]

func _physics_process(delta):
	if !Completed and fireballs == fireballsNeeded:
		$AnimationPlayer.play('receiverFull')
		puzzleCompleted()

func puzzleCompleted():
	for x in range(5):
		keyTarget = keyTargets[x]
		puzzleComplete(keyTarget)
	
	Completed = true
	$Sounds/Triggered.play()
	
func addFireball():
	fireballs += 1


func _on_Area2D_area_entered(area):
	destroyFireball(area.get_name())
	addFireball()

# Destroy Fireball
func destroyFireball(fireballName):
	if !Completed:
		_connect_destroyFireball_signal('../../Fireballs/' + fireballName)
		emit_signal('destroyFireball')
	

func _connect_destroyFireball_signal(fireball):
	var fireballNode = get_node(fireball)
	self.connect('destroyFireball', fireballNode, '_on_Receiver_destroyFireball', [fireballNode])

# Open keyTarget
func puzzleComplete(keyTarget):
	var targetNode = get_node(keyTarget)
	self.connect('puzzleComplete', targetNode, '_on_Receiver_puzzleCompleted')
	emit_signal('puzzleComplete')

func _on_AnimationPlayer_animation_finished(anim_name):
	pass # Replace with function body.
