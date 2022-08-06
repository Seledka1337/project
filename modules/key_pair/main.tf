data "aws_ssm_parameter" "key_pair" {
  name = "ssh-key_id_rsa.pub"
}

# create ssh key:
resource "aws_key_pair" "jenkins_ssh_key" {
  key_name   = "jenkins_project_ssh_key"
  public_key = sensitive(data.aws_ssm_parameter.key_pair.value)
}