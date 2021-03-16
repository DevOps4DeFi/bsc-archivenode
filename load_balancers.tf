## TODO re-add conditionally if no public ALB is provided
/*resource "aws_lb" "public_alb" {
  name               = "scout-public-alb"
  load_balancer_type = "application"
  subnets            = local.subnets
  security_groups    = [aws_security_group.public_alb_sg.id]
  internal           = false
  tags = merge(var.tags,
    {
      Name = "scout_public_alb"
  })
}
*/
data "aws_lb" "public_alb" {
  name = var.public_lb_name
}
data "aws_lb" "private_alb" {
  name = var.private_lb_name
}
resource "aws_lb_target_group" "bsc-jsonrpc-public" {
  name     = "bsc-jsonrpc-public"
  port     = "8545"
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  tags = {
    name = "bsc-geth"
  }
  health_check { ##TODO figure out a better healthcheck maybe getting data from the monitoring/management ports
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/"
    port                = 8545
  }
}
resource "aws_lb_target_group" "bsc-jsonrpc-private" {
  name     = "bsc-jsonrpc-private"
  port     = "8545"
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  tags = {
    name = "bsc-geth"
  }
  health_check { ##TODO figure out a better healthcheck maybe getting data from the monitoring/management ports
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/"
    port                = 8545
  }
}


## If so they need their own target groups.
resource "aws_lb_listener_rule" "bsc-node-public" {
  listener_arn = var.public_lb_https_listener_arn
  action {
    target_group_arn = aws_lb_target_group.bsc-jsonrpc-public.arn
    type             = "forward"
  }
  condition {
    host_header {
      values = [aws_route53_record.bsc-archive.fqdn]
    }
  }
}

resource "aws_lb_listener_rule" "bsc-node-private" {
  listener_arn = var.private_lb_https_listener_arn
  action {
    target_group_arn = aws_lb_target_group.bsc-jsonrpc-private.arn
    type             = "forward"
  }
  condition {
    host_header {
      values = [aws_route53_record.bsc-archive.fqdn]
    }
  }
}
