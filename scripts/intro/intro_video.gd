extends Node3D

@export var video_player: VideoStreamPlayer
@export var mesh: MeshInstance3D

func _ready():
	var material = mesh.get_active_material(0)
	material.albedo_texture = video_player.get_video_texture()
