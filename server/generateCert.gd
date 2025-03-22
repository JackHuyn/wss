extends Node

var x509_cert_fn = "X509_Certificate.crt" # name of application.crt
var x509_key_fn = "X509_Key.key" # name of application.key
@onready var X509_cert_path = "res://Certificate/" + x509_cert_fn
@onready var X509_key_path = "res://Certificate/" + x509_key_fn

var CN = "alienChess"
var O = "senior2025"
var C = "SWE"
var not_before = "20253003000000"  # Start time (modify if needed)
var not_after = "20263012000000"  # End time (modify if needed)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	createCert()

func createCert():
	var CNOC = "CN=" + CN + ",O=" + O + ",C=" + C
	var crypto = Crypto.new()
	
	# Generate RSA key pair
	var crypto_key = crypto.generate_rsa(4096)
	if crypto_key == null:
		print("Error generating RSA key.")
		return
	
	# Generate self-signed certificate
	var x509_cert = crypto.generate_self_signed_certificate(crypto_key, CNOC, not_before, not_after)
	if x509_cert == null:
		print("Error generating X509 certificate.")
		return
	
	# Save certificate and key to files
	var cert_saved = x509_cert.save(X509_cert_path)
	var key_saved = crypto_key.save(X509_key_path)
	
	if cert_saved and key_saved:
		print("Certificate & key generated and saved.")
	else:
		print("Error saving certificate or key.")
