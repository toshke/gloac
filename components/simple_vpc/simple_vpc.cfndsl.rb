tags = tags.collect { |k, v| { 'Name' => k, 'Value' => v } }


def extended_tags(map)
  new_tags = tags.clone
  new_tags.merge(map.collect { |k, v| { 'Name' => k, 'Value' => v } })
end

CloudFormation do

  cidr_components = cidr.split('.')
  cidr_components[3] = cidr_components[3].split('/')[0]
  subnet_bits = cidr.split('/')[1]

  if subnet_bits > 16
    STDERR.print('VPC CIDR must be at least w/16 subnet mask')
    exit 1
  end


  # check for private ranges
  given_range = NetAddr::CIDR.create(cidr)
  r1 = NetAddr::CIDR.create('172.16.0.0/12')
  r2 = NetAddr::CIDR.create('10.0.0.0/8')
  r3 = NetAddr::CIDR.create('192.168.0.0/16')
  ok = (r1.contains? given_range) or (r2.contains? given_range) or (r3.contains? given_range)
  unless ok
    STDERR.print("CfndDSL VPC: #{cidr} must be valid range!")
    exit 1
  end

  EC2_VPC('VPC') do
    CidrBlock cidr
    EnableDnsHostnames true
    EnableDnsSupport true
    InstanceTenancy 'default'
    Tags extended_tags({ 'Name' => name })
  end


  if internet_enabled
    EC2_InternetGateway('Gateway') do
      Tags extended_tags({ 'Name' => "gateway#{name}" })
    end

    VPCGatewayAttachment('GatewayAttachment') do
      VpcId Ref('VPC')
      VpnGatewayId Ref('Gateway')
    end


  end

  subnet_counter = 0
  current_subnet = "#{cidr_components[0]}.#{cidr_components[1]}.#{subnet_counter}.0/24"

  ## subnets
  ## public subnets
  if internet_enabled
    availability_zones.each do

      subnet_counter = subnet_counter + 1
      current_subnet = "#{cidr_components[0]}.#{cidr_components[1]}.#{subnet_counter}.0/24"
    end
  end
    ## private subnets

    ## route tables

    ## NACLs


    ## endpoints
    EC2_VPCEndpoint('VPCEndpoint') do
      VpcId Ref('VPC')
      PolicyDocument({
          Version: '2012-10-17',
          Statement: [{
              Effect: 'Allow',
              Principal: '*',
              Action: ['s3:*'],
              Resource: ['arn:aws:s3:::*']
          }]
      })
      ServiceName FnJoin("", ['com.amazonaws.', Ref('AWS::Region'), '.s3'])
      RouteTableIds route_tables

    end


    ## Outputs
    Output('VPCId') do
      Value Ref('VPC')
    end
  end