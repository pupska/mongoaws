provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

//take our ip addr
data "http" "ip" {
  url = "http://icanhazip.com"
}

data "aws_route53_zone" "selected" {
  name         = "${var.dns_zone}"
  private_zone = true
}

resource "aws_security_group" "MongoSG" {
  name_prefix = "mongo_rs_SG"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    self      = true
  }

  //rule for access from node where terraform executed
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "${chomp(data.http.ip.body)}/32",
    ]
  }
}

resource "aws_instance" "mongo" {
  count                       = "${var.amount_of_nodes}"
  ami                         = "${var.base_ami}"
  instance_type               = "t2.micro"
  subnet_id                   = "${element(var.subnets, count.index )}"
  security_groups             = ["${aws_security_group.MongoSG.id}"]
  key_name                    = "${var.aws_ssh_key_name}"
  associate_public_ip_address = true

  ebs_block_device {
    device_name = "/dev/xvdg"
    volume_size = "${var.external_storage_size}"
  }

  tags {
    Name = "mongo-node-${count.index}"
  }

  provisioner "local-exec" {
    command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u centos --private-key ${var.path_to_ssh_key} -i '${self.public_ip},' ansible/provision_node.yaml --tags first --extra-vars ${local.docker_image} "
  }
}

resource "aws_route53_record" "mongo_dns" {
  // same number of records as instances
  count   = "${var.amount_of_nodes}"
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "mongo-0${count.index}"
  type    = "A"
  ttl     = "300"

  // matches up record N to instance N
  records = ["${element(aws_instance.mongo.*.private_ip, count.index)}"]
}

locals {
  mongo_nodes = "{\"mongo_nodes\": [ ${join(",", aws_route53_record.mongo_dns.*.fqdn)} ]}"
  first_aws_instance = "${element(aws_instance.mongo.*.public_ip, 0)}"
  docker_image = "\"mongo_image=${var.mongo_image}\""
}

resource "null_resource" "init_replicaset" {
  depends_on = ["aws_route53_record.mongo_dns"]

  provisioner "local-exec" {
    command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u centos --private-key ${var.path_to_ssh_key} -i '${local.first_aws_instance},' ansible/provision_node.yaml --tags leader --extra-vars='${local.mongo_nodes}' "
  }
}

output "instance_ips" {
  value = ["${aws_instance.mongo.*.public_ip}"]
}