resource "null_resource" "vps_base_setup" {

    triggers = {
  always_run = timestamp()
}

  connection {
    type        = "ssh"
    host        = var.vps_ip
    user        = var.vps_user
    private_key = file(var.ssh_private_key_path)
  }

  provisioner "file" {
    source      = "scripts/setup_vps.sh"
    destination = "/tmp/setup_vps.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup_vps.sh",
      "/tmp/setup_vps.sh"
    ]
  }
}
