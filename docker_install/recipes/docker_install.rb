execute "Update yum" do
  command "yum makecache fast"
  action :run
  end

package "docker" do
  action :install
end

service "docker" do
  action :enable
end

bash "docker_insecure_registry" do
  user 'root'
  cwd '/'
  code <<-EOH
  echo "INSECURE_REGISTRY='--insecure-registry=#{node.default["insecure_registry"]}'" >> #{node.default["docker_options_file"]}
  systemctl daemon-reload
  systemctl start docker
  EOH
end
