# Cookbook Name:: groonga
# Recipe:: default
# License:: Apache 2.0
#
# Copyright 2013 Kouhei Sutou <kou@clear-code.com>

if platform_family?("debian")
  package "lsb-release" do
    action [:install]
  end

  template "/etc/apt/sources.list.d/groonga.list" do
    extend Chef::Mixin::ShellOut
    source "groonga.list.erb"
    platform = node.platform
    apt_policy = shell_out!("apt-cache", "policy").stdout
    if /(?:[an]=)(?:unstable|sid),/ =~ apt_policy
      code_name = "unstable"
    else
      code_name = shell_out!("lsb_release", "--short", "--codename").stdout.strip
    end
    case platform
    when "debian"
      component = "main"
    when "ubuntu"
      component = "universe"
    end
    variables(:platform  => platform,
              :code_name => code_name,
              :component => component)
  end

  package "groonga-keyring" do
    options("--allow-unauthenticated")
    action [:install]
  end
end

package "groonga" do
  action [:install]
end
