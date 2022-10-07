#resource "digitalocean_vpc" "project-vpc" {
#      #id          = "280a75ce-dc83-11e8-beb4-3cfdfea9fb81"
#      ip_range    = "10.130.0.0/16"
#      name        = "mai-project-vpc-sgp"
#      region      = "sgp1"
#      #urn         = "do:vpc:280a75ce-dc83-11e8-beb4-3cfdfea9fb81"
#}

/* resource "digitalocean_project" "test-project" {
  name        = "Mai Labs"
  description = "MicroAd Developer Labs"
  purpose     = "Operational / Developer tooling"
  environment = "Development"
} */

/* resource "digitalocean_volume" "test-volume" {
  region                  = "sgp1"
  name                    = "vols"
  size                    = 20
  initial_filesystem_type = "ext4"
  description             = "an example volume"
} */

resource "digitalocean_droplet" "sharecar" {
  image  = "centos-stream-8-x64"
  name   = "sharecar.co.id"
  region = "sgp1"
  size   = "s-2vcpu-2gb"
  #vcpus  = 2
  #memory = 2048
  #disk   = 60
  tags   = [
              "client",
              "mufid"
            ]
  #vpc_uuid = digitalocean_vpc.project-vpc

  monitoring  = true
  ipv6     = true
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    #timeout = "2m"
  }
  
  provisioner "remote-exec" {
    inline = [
      #"export PATH=$PATH:/usr/bin",
      # update OS
      "sudo yum check-update",
      "sudo yum -y update",
      "sudo yum -y clean all",
      #install docker
      "sudo yum install -y yum-utils",
      "sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo",
      "sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      #install docker-compose
      "curl -SL https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "docker-compose --version",
      #install gitlab-runner
      "curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64",
      "chmod +x /usr/local/bin/gitlab-runner",
      "useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash",
      "gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner",
      "gitlab-runner start",
      #install git
      "sudo yum -y install git",
      #install netstat
      "sudo yum -y install net-tools",
      #add gitlab runner user to docker group
      "sudo usermod -a -G docker gitlab-runner"
    ]
  }
}

#resource "digitalocean_volume_attachment" "attach-vol" {
#  droplet_id = digitalocean_droplet.test
#  volume_id  = digitalocean_volume.test-volume
#}

output "droplet_ip_address" {
  value = digitalocean_droplet.sharecar.ipv4_address
}