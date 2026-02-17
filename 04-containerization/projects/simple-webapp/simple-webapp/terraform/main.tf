# NETWORKING DATA 
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

module "alb" {
  source  = "./modules/alb"
  name    = "webapp-alb"
  vpc_id  = data.aws_vpc.default.id
  subnets = data.aws_subnets.default.ids
}


# ECS INFRASTRUCTURE
resource "aws_ecs_cluster" "main" {
  name = "simple-webapp-cluster"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "web-app-task-execution-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "ecs-tasks.amazonaws.com" } }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_ecs_service" "main" {
  name            = "webapp-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = data.aws_subnets.default.ids
    # Get the SG ID from the module output!
    security_groups  = [module.alb.alb_security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = module.alb.target_group_arn # Using the module output!
    container_name   = "webapp"
    container_port   = 3000
  }

  depends_on = [module.alb]

  health_check_grace_period_seconds = 60 # Gives the app 1 minute to start before failing health checks
}

# cloudwatch log group for ECS task logs
# 1. Create the Log Group
resource "aws_cloudwatch_log_group" "webapp_logs" {
  name              = "/ecs/simple-webapp"
  retention_in_days = 7 # Keep logs for 7 days to save costs
}

# 2. Define the Task Definition with two containers: the web app and Redis sidecar
resource "aws_ecs_task_definition" "app" {
  family                   = "web-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"  # Increased CPU to handle two containers
  memory                   = "1024" # Increased Memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    # Container 1: The Node.js Web App
    {
      name      = "webapp"
      image     = "${var.docker_hub_username}/simple-webapp:latest"
      essential = true
      portMappings = [{
        containerPort = 3000
        hostPort      = 3000
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.webapp_logs.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "webapp"
        }
      }

      environment = [
        { name = "REDIS_URL", value = "redis://localhost:6379" },
        { name = "APP_THEME", value = var.app_theme }, # This passes the Terraform var to the container
        { name = "DEPLOY_TIMESTAMP", value = timestamp() }

      ]
    },

    # Container 2: Redis Sidecar
    {
      name      = "redis"
      image     = "redis:alpine"
      essential = true
      portMappings = [{
        containerPort = 6379
        hostPort      = 6379
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.webapp_logs.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "redis"
        }
      }
    }
  ])
}