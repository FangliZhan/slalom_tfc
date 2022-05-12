terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # version = "= 3.42.0"
      version = "~> 3.69"
    }
  }
}

provider "aws" {
  region  = var.region
}

// create iam users in AWS
resource "aws_iam_user" "demo" {
  count = "${length(var.username)}"
  name = "${element(var.username,count.index )}"
}


//create a login profile for the users

resource "aws_iam_user_login_profile" "demo" {
  # user    = aws_iam_user.demo.*.name
  count = length(var.username)
  user = aws_iam_user.demo[count.index].name
  password_reset_required = true
  pgp_key = "keybase:rosezhan2022"
}


// assign policies to users
resource "aws_iam_user_policy" "user_policy" {
  count = length(var.username)
  name = "new"
  # user = element(var.username,count.index)
  user = aws_iam_user.demo[count.index].name
policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ec2:Describe*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:Describe*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:Describe*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:Describe*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_account_password_policy" "strict" {
    minimum_password_length             = 8
    require_lowercase_characters        = true
    require_numbers                     = true
    require_uppercase_characters        = true
    require_symbols                     = true
    allow_users_to_change_password      = true
}

//decrypt the output passwords
// terraform output password | base64 --decode | keybase pgp decrypt
// echo "password" | base64 --decode | keybase pgp decrypt

//account id: 115591414427


