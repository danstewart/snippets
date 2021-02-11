server_name='some-server-name'
region='eu-west-2'

# Take some JSON and reduce it down to a subset of fields
aws ec2 describe-instances --output json --filters "Name=tag:Name,Values=*$server_name*" --region $region | jq '[.Reservations[].Instances[]] | map({ InstanceId, PublicIpAddress, PrivateIpAddress, Tags })'
