docker_container 'current_tomcat' do
  action [:stop, :delete]
end

ruby_block 'rename release_tomcat to current_tomcat' do
    block do
      command = 'sudo docker rename release_tomcat current_tomcat'
      shell_out(command).stdout.to_s
    end
end