resource "aws_ecr_repository" "ecr_empowermentlabs_fe" {
  name                 = var.ecr_name_fe
  image_tag_mutability = "MUTABLE"


  image_scanning_configuration {
    scan_on_push = true
  }
}


resource "aws_ecr_repository" "ecr_empowermentlabs_be" {
  name                 = var.ecr_name_be
  image_tag_mutability = "MUTABLE"


  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecs_cluster" "cluster_frontend" {
  name = "cluster-ecs-fe"

  setting {
      name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_ecs_cluster" "cluster_backend" {
  name = "cluster-ecs-be"

  setting {
      name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_ecs_task_definition" "task-def" {
  family                   = "task-def"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = jsonencode([
    {
      name      = "app-container"
      image     = "aogilt/app-empowermentlabs:latest"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_ecs_service" "service-frontend" {
  name            = "frontend_app"
  launch_type     = "FARGATE" 
  cluster         = aws_ecs_cluster.cluster_frontend.id
  task_definition = aws_ecs_task_definition.task-def.arn 
  desired_count   = 2
  
  load_balancer {
    target_group_arn = aws_lb_target_group.ip-tg_frontend.arn
    container_name   = "app-container"
    container_port   = var.container_port
  }

network_configuration {
    subnets          = [var.private_subnet1_id , var.private_subnet2_id]
    assign_public_ip = false
    security_groups = [
      aws_security_group.sg_frontend.id
    ]
  }
  depends_on = [
    aws_lb_target_group.ip-tg_frontend , aws_security_group.sg_frontend
  ]
}

resource "aws_ecs_service" "service-backend" {
  name            = "backend_app"
  launch_type     = "FARGATE"
  cluster         = aws_ecs_cluster.cluster_backend.id
  task_definition = aws_ecs_task_definition.task-def.arn
  desired_count   = 2

  load_balancer {
    target_group_arn = aws_lb_target_group.ip-tg_backtend.arn
    container_name   = "app-container"
    container_port   = var.container_port
  }

network_configuration {
    subnets          = [var.private_subnet3_id , var.private_subnet4_id]
    assign_public_ip = false
    security_groups = [
      aws_security_group.sg_backend.id
    ]
  }
  depends_on = [
    aws_lb_target_group.ip-tg_backtend , aws_security_group.sg_backend
  ]
}

resource "aws_lb" "alb-frontend" {
  name               = "alb-frontend"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_frontend.id]
  subnets            = [var.public_subnet1_id , var.public_subnet2_id] 


  tags = {
    name = "alb-fe"
  }

  depends_on = [
    aws_lb_target_group.ip-tg_frontend, aws_security_group.sg_frontend
  ]
}

resource "aws_lb" "alb-backend" {
  name               = "alb-backend"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_backend.id]
  subnets            = [var.private_subnet1_id , var.private_subnet2_id]


  tags = {
    name = "alb-be"
  }

  depends_on = [
    aws_lb_target_group.ip-tg_frontend, aws_security_group.sg_frontend
  ]
}


resource "aws_lb_listener" "listener_frontend" {
  load_balancer_arn = aws_lb.alb-frontend.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ip-tg_frontend.arn
  }

depends_on = [
    aws_lb.alb-frontend , aws_lb_target_group.ip-tg_frontend
  ]
  
}


resource "aws_lb_listener" "listener_backend" {
  load_balancer_arn = aws_lb.alb-backend.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ip-tg_backtend.arn
  }

depends_on = [
    aws_lb.alb-backend , aws_lb_target_group.ip-tg_backtend
  ]

}

resource "aws_lb_target_group" "ip-tg_frontend" {
  name        = "tg-Prueba-empowermentlabs-fe"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group" "ip-tg_backtend" {
  name        = "tg-Prueba-empowermentlabs-be"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_security_group" "sg_frontend" {
  name        = "sg_frontend"
  description = "Allow traffic to app FairPay"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 8000
    to_port          = 8000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Security group Prueba empowermentlabs"
  }
}

resource "aws_security_group" "sg_backend" {
  name        = "sg_backend"
  description = "Allow traffic to app FairPay Backend"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [aws_security_group.sg_frontend.id]
  }

  ingress {
    from_port        = 8000
    to_port          = 8000
    protocol         = "tcp"
    security_groups = [aws_security_group.sg_frontend.id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Security group Prueba empowermentlabs -  backend"
  }
  depends_on = [aws_security_group.sg_frontend]
}
