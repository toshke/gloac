CloudFormation do


  subnets = []
  markers = %w(A B C D E F G H)
  availability_zones.each_with_index do |az, ix|
    subnets << Ref("Subnet#{markers[ix]}")
  end

  EC2_SecurityGroup('SecurityGroupRedis') do
    VpcId Ref('VPCId')
    GroupDescription "#{name} redis SG"
    Tags [{ Key: 'Name', Value: "#{name}-security-group" }]
  end

  ElastiCache_SubnetGroup('RedisSubnetGroup') do
    Description "#{name} subnet group"
    SubnetIds subnets
  end

  ElastiCache_ParameterGroup('RedisParameterGroup') do
    CacheParameterGroupFamily family
    Description "#{name} parameter group"
    Properties parameters if defined? parameters
  end unless cluster

  cluster_parameters = { 'cluster-enabled': 'yes' }
  cluster_parameters.merge!(parameters) if defined? parameters

  ElastiCache_ParameterGroup('RedisParameterGroup') do
    CacheParameterGroupFamily family
    Description "#{name} cluster parameter group"
    Properties cluster_parameters
  end if cluster

  if (restore_from_s3_snapshot and restore_from_snapshot) then
    STDERR.write('Only one of restore_from_s3_snapshot and restore_from_snapshot allowed')
    exit 2
  end
  if restore_from_s3_snapshot then
    Condition('S3SnapshotEmpty', FnIf(FnEquals(Ref('S3Snapshot'), '')))
    snapshot_value = FnIf('S3SnapshotEmpty', Ref('S3Snapshot'), Ref('AWS::NoValue'))
  end
  if restore_from_snapshot then
    Condition('SnapshotEmpty', FnIf(FnEquals(Ref('Snapshot'), '')))
    snapshot_value = FnIf('SnapshotEmpty', Ref('Snapshot'), Ref('AWS::NoValue'))
  end

  ElastiCache_ReplicationGroup('ReplicationGroup') do
    ReplicationGroupDescription "#{name} - replica group"
    Engine 'redis'
    AutoMinorVersionUpgrade minor_upgrade_auto
    Port port
    CacheNodeType cache_instance_type
    CacheParameterGroupName Ref('RedisParameterGroup')
    CacheSubnetGroupName Ref('RedisSubnetGroup')
    SecurityGroupIds [Ref('SecurityGroupRedis')]
    AtRestEncryptionEnabled encrypt_at_rest

    AutomaticFailoverEnabled (cluster and cluster_size > 1)
    if cluster
      NumCacheClusters num_clusters
    else
      NumCacheClusters 1
    end

    TransitEncryptionEnabled true if encrypt_at_transit
    SnapshotArns snapshot_value if restore_from_s3_snapshot
    SnapshotName snapshot_value if restore_from_snapshot
    SnapshotRetentionLimit snapshot_retention_days
    Tags [{ Key: 'Name', Value: name }]
  end


end
