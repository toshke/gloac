CfhighlanderTemplate do


  markers = %w(A B C D E F G H)

  Parameters do
    ComponentParam 'VPCId', type: 'AWS::EC2::VPC::Id'
    availability_zones.each_with_index do |az, ix|
      ComponentParam "Subnet#{markers[ix]}", type: 'AWS::EC2::Subnet::Id',
          description: "Select subnet for AZ #{az}"
    end
    ComponentParam ('S3Snapshot') if restore_from_s3_snapshot
    ComponentParam('Snapshot') if restore_from_snapshot
    ComponentParam 'AllowedSGs', type: 'List<AWS::EC2::SecurityGroup::Id>',
        description: 'Select Security Groups allowed to connect to this Redis instance'
  end

end