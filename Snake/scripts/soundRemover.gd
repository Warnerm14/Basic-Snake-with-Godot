## Made by Warnerm14
extends AudioStreamPlayer

func _on_finished():
	queue_free()
