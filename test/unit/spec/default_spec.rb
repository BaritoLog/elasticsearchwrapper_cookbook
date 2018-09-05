require_relative 'spec_helper'

describe 'elasticsearch_wrapper_cookbook::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '18.04') do |node|
      node.normal['elasticsearch']['version'] = '99.99'
      node.normal['elasticsearch']['user'] = 'elasticsearch'
      node.normal['elasticsearch']['data_directory'] = '/var/lib/elasticsearch'
      node.normal['elasticsearch']['port'] = '9200'
      node.normal['elasticsearch']['bulk_queue_size'] = '10'
      node.normal['elasticsearch']['auto_create_index'] = true
      allow(node).to receive(:hostname).and_return('hostname')
    end.converge(described_recipe)
  end

  it 'should create elasticsearch user' do
    expect(chef_run).to create_elasticsearch_user('elasticsearch')
  end

  it 'should install elastic search' do
    expect(chef_run).to install_elasticsearch('elasticsearch').with(
      type: 'package',
      version: '99.99',
      action: %i[install]
    )
  end

  it 'should create elastic search data directory' do
    expect(chef_run).to create_directory('/var/lib/elasticsearch').with(
      owner: 'elasticsearch',
      group: 'elasticsearch',
      action: %i[create]
    )
  end

  it 'should configure elastic search' do
    expect(chef_run).to manage_elasticsearch_configure('elasticsearch').with(
      allocated_memory: nil,
      jvm_options: %w[
        -Xss1m
        -XX:+UseConcMarkSweepGC
        -XX:CMSInitiatingOccupancyFraction=75
        -XX:+UseCMSInitiatingOccupancyOnly
        -XX:+DisableExplicitGC
        -XX:+AlwaysPreTouch
        -server
        -Djava.awt.headless=true
        -Dfile.encoding=UTF-8
        -Djna.nosys=true
        -Dio.netty.noUnsafe=true
        -Dio.netty.noKeySetOptimization=true
        -Dlog4j.shutdownHookEnabled=false
        -Dlog4j2.disable.jmx=true
        -Dlog4j.skipJansi=true
        -XX:+HeapDumpOnOutOfMemoryError
        -Djava.io.tmpdir=/tmp
      ],
      configuration: {
        'path.data' => '/var/lib/elasticsearch',
        'node.name' => 'hostname',
        'http.port' => '9200',
        'network.host' => 'hostname',
        'bootstrap.memory_lock' => false,
        'thread_pool.bulk.size' => 1,
        'thread_pool.bulk.queue_size' => '10',
        'action.auto_create_index' => true
      },
      action: %i[manage]
    )
  end

  # TODO: this is not working, should be refactored
  # it 'should configure limits for elastic search' do
  #   expect(chef_run).to create_limits_config('elasticsearch').with(
  #     limits: [
  #       { domain: 'elasticsearch', type: 'hard', value: 'unlimited', item: 'memlock' },
  #       { domain: 'elasticsearch', type: 'soft', value: 'unlimited', item: 'memlock' }
  #     ]
  #   )
  # end

  it 'should configure sysctl - vm.max_map_count value' do
    expect(chef_run).to apply_sysctl('vm.max_map_count').with(
      value: '262144'
    )
  end

  it 'should symlink /usr/share/elasticsearch/config' do
    link = chef_run.link('/usr/share/elasticsearch/config')
    expect(link).to link_to('/etc/elasticsearch/')
  end

  it 'should enable elasticsearch service actions' do
    expect(chef_run).to configure_elasticsearch_service('elasticsearch').with(
      service_actions: %i[start enable restart]
    )
  end
end
