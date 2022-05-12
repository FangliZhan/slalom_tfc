//output the password for each user
output "password" {
  value = aws_iam_user_login_profile.demo.*.encrypted_password
}

// output each user name
output "user_arn" {
  value = aws_iam_user.demo.*.arn
}
