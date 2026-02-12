resource "aws_ecs_cluster" "cluster" {
    name = "the-cluster"

    configuration {
      execute_command_configuration {
        log_configuration {
          cloud_watch_log_group_name = aws_cloudwatch_log_group.container.name
        }
      }
    }
}

resource "aws_ecs_task_definition" "service" {
    family = "service"
    requires_compatibilities = ["FARGATE"]
    cpu = 1024
    memory = 2048
    execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
    container_definitions = jsonencode([
        {
            name = local.container_name
            image = var.IMAGE_NAME
            essential = true
            logConfiguration = {
                logDriver = "awslogs"
                options = {
                    "awslogs-group" = aws_cloudwatch_log_group.container.name
                    "awslogs-region" = var.AWS_REGION
                    "awslogs-stream-prefix" = local.container_name
                }
            }
        }
    ])

    runtime_platform {
        operating_system_family = var.TASK_OS_FAMILY
        cpu_architecture = var.TASK_CPU_ARCH
    }
}

resource "aws_ecs_service" "service" {
    name = "the-service"
    cluster = aws_ecs_cluster.cluster.id
    task_definition = aws_ecs_task_definition.service.arn
    launch_type = "FARGATE"

    load_balancer {
        target_group_arn = aws_lb_target_group.target.arn
        container_name   = local.container_name
        container_port   = var.IMAGE_PORT
    }
}