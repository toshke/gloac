CfhighlanderTemplate do

  markers = %w(A B C D E F G)

  if provision_vpc

    Component name: 'vpc', template: 'simple-vpc' do
    end

  end

  if elasticache_redis
    Component name 'redis-elasticache' do
      if provision_vpc
        availability_zones.each_with_index do |az, ix|
          parameter name: "Subnet#{ix}", value: "simple-vpc.Private#{ix}"
        end
      end
    end
  end
end
