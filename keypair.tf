resource "aws_key_pair" "mazz-key" {
  key_name   = "mazz-key"
  public_key = file("${path.module}/${var.PUBLIC_KEY_PATH}")
}
