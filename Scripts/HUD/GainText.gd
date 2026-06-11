class_name GainText extends Control


var offset: Vector2 = Vector2(0,-22)

var _is_displaying: bool = false

var _tween : Tween
func gain(
	_text:String, _wait:float=0.35,  _duration:float=2.0, _movement:Vector2=Vector2(0,-10),
	_ease_type:Tween.EaseType=Tween.EaseType.EASE_OUT,
	_trans_type: Tween.TransitionType = Tween.TransitionType.TRANS_SINE
	) -> void:

	if _is_displaying: return
	_is_displaying = true
	
	$GainTextLabel.text = _text
	global_position = PlayerCharacter.instance.get_viewport().get_canvas_transform() * PlayerCharacter.instance.global_position + offset
	
	await get_tree().create_timer(_wait).timeout
	
	if _tween: return
	_tween = create_tween().set_ease(_ease_type).set_trans(_trans_type).set_parallel()
	_tween.tween_property(self,"modulate",Color(modulate,0),_duration)
	_tween.tween_property(self,"global_position",global_position + _movement,_duration)
	_tween.tween_callback(queue_free).set_delay(_duration)
