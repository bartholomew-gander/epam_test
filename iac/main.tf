variable "AWS_REGION" {
    type = string
}

variable "IMAGE_NAME" {
    type = string
}
variable "IMAGE_PORT" {
    type = string
}

variable "TASK_OS_FAMILY" {
    type = string
    default = "LINUX"
}

variable "TASK_CPU_ARCH" {
    type = string
    default = "X86_64"
}

resource "aws_kms_key" "key" {
  description             = "key"
  deletion_window_in_days = 7
}


resource "aws_iam_policy" "policy" {
    name = "write-logs-policy"
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ]
                Resource = "${aws_cloudwatch_log_group.container.arn}:*"
            }
        ]
    })
}

resource "aws_iam_role" "ecs_task_execution_role" {
    name = "ecsTaskExecutionRole"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "ecs-tasks.amazonaws.com"
                }
                Action = "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "attachment" {
    role = aws_iam_role.ecs_task_execution_role.name
    policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
    role = aws_iam_role.ecs_task_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
}

resource "aws_lb" "lb" {
    name = "lb"
    load_balancer_type = "application"
    subnets = [aws_subnet.public.id] // TODO: add subnets
}

resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.lb.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.target.arn
    }
}

resource "aws_lb_target_group" "target" {
    name = "lb-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.main.id
}

resource "aws_cloudwatch_log_group" "container" {
    name = "container-log-group"
}

locals {
  container_name = "the-container"
}
