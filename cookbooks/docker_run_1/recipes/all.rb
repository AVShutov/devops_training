docker_image node.default["image"] do
  tag node.default["version"]
  action :pull_if_missing
end

def getPort
    Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)      
    curl_command = 'curl --write-out %{http_code} --silent --output /dev/null '+node['url']
    curl_command_out = shell_out(curl_command)
    if curl_command_out.stdout == "200"
       return_port = '8081'
    else
       return_port = '8080'
    end
    return return_port
end

av_port = getPort

docker_container 'release_tomcat' do
  repo node['image']
  tag node['version']
  port "#{av_port}:8080"
  action :run
end

docker_container 'current_tomcat' do
  action [:stop, :delete]
end

ruby_block 'rename release_tomcat to current_tomcat' do
    block do
      command = 'sudo docker rename release_tomcat current_tomcat'
      shell_out(command).stdout.to_s
    end
end