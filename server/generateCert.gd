extends Node

var x509_cert_fn = "X509_Certificate.crt" # name of application.crt
var x509_key_fn = "X509_Key.key" # name of application.key
@onready var X509_cert_path = "res://Certificate/" + x509_cert_fn
@onready var X509_key_path = "res://Certificate/" + x509_key_fn

#CN = mysserver
#0 = myOrganization
#C = IT

var CN = "alienChess"
var O = "senior2025"
var C = "SWE"
var not_before = "20253003000000"
var not_after = "20263012000000"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var directory = DirAccess
	var dir = directory.instantiate()
	if dir.dir_exists("res://Certificate"):
		pass
	else:
		dir.make_dir("res://Certificate")
	createCert()
	print("Certificate & key generated")

func createCert():
	var CNOC = "CN=" + CN + ",O=" + O + ",C=" + C
	var crypto = Crypto.new()
	var crypto_key = crypto.generate_rsa(4096)
	var x509_cert = crypto.generate_self_signed_certificate(crypto_key,CNOC, not_before,not_after)
	x509_cert.save(X509_cert_path)
	crypto_key.save(X509_key_path)
