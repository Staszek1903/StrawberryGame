extends RigidBody2D

@onready
var polygon:Polygon2D = $Polygon2D

var point_origins:PackedVector2Array
# Called when the node enters the scene tree for the first time.

func _ready():
	point_origins = polygon.polygon.duplicate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
