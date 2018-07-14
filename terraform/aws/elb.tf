variable "prefix" {
  type = "string"
}

variable "access_key" {
  type = "string"
}

variable "secret_key" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

variable "elb_subnet_ids" {
  type = "list"
}

variable "elasticsearch_port" {
  default = 9200
}

variable "kibana_port" {
  default = 5601
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_elb" "elasticsearch" {
  name            = "${var.prefix}-elasticsearch"
  subnets         = "${var.elb_subnet_ids}"
  security_groups = ["${aws_security_group.elasticsearch.id}"]

  listener {
    instance_port     = "${var.elasticsearch_port}"
    instance_protocol = "tcp"
    lb_port           = "${var.elasticsearch_port}"
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = "${var.kibana_port}"
    instance_protocol = "tcp"
    lb_port           = "${var.kibana_port}"
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = "443"
    instance_protocol = "tcp"
    lb_port           = "443"
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 6
    unhealthy_threshold = 3
    timeout             = 3
    target              = "TCP:${var.elasticsearch_port}"
    interval            = 5
  }
}

resource "aws_security_group" "elasticsearch" {
  name   = "${var.prefix}-elasticsearch"
  vpc_id = "${var.vpc_id}"
}

resource "aws_security_group_rule" "outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.elasticsearch.id}"
}

resource "aws_security_group_rule" "elasticsearch" {
  type        = "ingress"
  from_port   = "${var.elasticsearch_port}"
  to_port     = "${var.elasticsearch_port}"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.elasticsearch.id}"
}

resource "aws_security_group_rule" "kibana" {
  type        = "ingress"
  from_port   = "${var.kibana_port}"
  to_port     = "${var.kibana_port}"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.elasticsearch.id}"
}

resource "aws_security_group_rule" "https" {
  type        = "ingress"
  from_port   = "443"
  to_port     = "443"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.elasticsearch.id}"
}

output "elasticsearch_lb_name" {
  value = "${aws_elb.elasticsearch.name}"
}

output "elasticsearch_lb_dns_name" {
  value = "${aws_elb.elasticsearch.dns_name}"
}

output "elasticsearch_security_group" {
  value = "${aws_security_group.elasticsearch.id}"
}