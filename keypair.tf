resource "aws_key_pair" "mazz-key" {
  key_name   = "mazz-key"
  public_key = file("~/.ssh/id_rsa.pub")
}
