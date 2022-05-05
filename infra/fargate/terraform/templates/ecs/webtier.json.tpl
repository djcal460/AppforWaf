[
  {
    "name": "${container_name}",
    "image": "${ecr_image_uri}@${ecr_image_digest}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${awslogs_group}",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${ecs_container_port},
        "hostPort": ${docker_image_port}
      }
    ]
  }
]
