extends Node2D

@onready var Users = find_child("Users")
@onready var Username = find_child("Username")

signal register
signal load_users

var userId = null
var users = []

func loadUsers():
	emit_signal("load_users")
	print("load users")
	await get_tree().create_timer(5).timeout
	loadUsers()

func _on_register_pressed():
	if (len(Username.text) > 0 && userId == null):
		emit_signal("register", Username.text)

# Called when the node enters the scene tree for the first time.
func _ready():
	loadUsers()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_net_code_users_response(usersResp):
	users = usersResp
	var selection = Users.get_selected_items()
	Users.clear()
	for user in users:
		if user.id == userId:
			Users.add_item(user.name + "(you)")
		else:
			Users.add_item(user.name)
	if len(selection) > 0:
		Users.select(selection[0])

func _on_net_code_register_response(id):
	print('here')
	userId = id

func _on_challenge_pressed():
	var selection = Users.get_selected_items()
	if len(selection) > 0:
		var user = users[selection[0]]
		print(user)
