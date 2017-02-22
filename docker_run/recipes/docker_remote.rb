docker_image node.default["image"] do
  tag node.default["version"]
  action :pull
end

docker_container node.default["container"] do
  repo node.default["image"]
  tag node.default["version"]
  port '8082:8080'
  action :run
end