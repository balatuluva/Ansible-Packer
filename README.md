# Ansible-Packer
Ansible-Packer
$Env:AWS_ACCESS_KEY_ID="XXXX" 
$Env:AWS_SECRET_ACCESS_KEY="XXX" 
$Env:AWS_DEFAULT_REGION="us-east-1"

packer build --var-file vars.json packer.json