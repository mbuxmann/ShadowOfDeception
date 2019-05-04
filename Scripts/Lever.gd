extends Area2D

export(NodePath) var gateTarget

var leverStateOn = false

signal changeGateState

func _on_Player_changeLever(canAttack):
	if canAttack == true:
		changeLeverState()
	
	
func changeLeverState():
	if !leverStateOn:
		leverStateOn = true
		$AnimationPlayer.play('leverOn')
		_on_AnimationPlayer_animation_finished('leverOn')
		changeGateState(gateTarget)
	elif leverStateOn:
		leverStateOn = false
		$AnimationPlayer.play('leverOff')
		changeGateState(gateTarget)
		
func _on_AnimationPlayer_animation_finished(anim_name):
	return

func changeGateState(gateTarget):
	var gateNode = get_node(gateTarget)
	self.connect('changeGateState', gateNode, '_on_lever_changeGateState', [leverStateOn])
	emit_signal('changeGateState')
	self.disconnect('changeGateState', gateNode, '_on_lever_changeGateState')