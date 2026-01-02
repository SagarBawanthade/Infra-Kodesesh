variable "vps_ip" {
  description = "Public IP of VPS"
}

variable "vps_user" {
  description = "SSH user"
  default     = "sagar"
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key"
}
