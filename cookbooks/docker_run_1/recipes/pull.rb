docker_image node.default["image"] do
  tag node.default["version"]
  action :pull_if_missing
end