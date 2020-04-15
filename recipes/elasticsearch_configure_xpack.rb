ca = node['elasticsearch']['ca']
key_name = node['elasticsearch']['xpack_security_transport_ssl_keystore_path']

if version >= '7.0.0' && version < '8.0.0' do
  bash 'Setup certificate' do
    user 'root'
    cwd ::File.dirname('/usr/share/elasticsearch')
    code <<-EOF
      rm -f ca.p12
      bash64 -d #{ca} >> ca.p12
      /usr/bin/expect -c 'bin/elasticsearch-certutil cert --ca ca.p12
      expect "Enter password for CA (ca.p12) : "
      send ""      
      expect "Please enter the desired output file [elastic-certificates.p12]: "
      send #{key_name}
      expect "Enter password for #{key_name} : "
      send ""
      expect eof'
      mv #{keyname} /etc/elasticsearch/#{keyname}
      chown elasticsearch:elasticsearch /etc/elasticsearch/#{keyname}
    EOF
  end
end