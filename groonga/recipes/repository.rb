# Cookbook Name:: groonga
# Recipe:: default
#
# Copyright 2013 Kouhei Sutou <kou@clear-code.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if platform_family?("debian")
  include_recipe "apt"

  package "lsb-release" do
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
    notifies :run, resources(:execute => "apt-get update"), :immediately
  end

  package "groonga-keyring" do
    options("--allow-unauthenticated")
    notifies :run, resources(:execute => "apt-get update"), :immediately
  end
elsif platform_family?("rhel", "fedora")
  if platform_family?("rhel")
    family = "centos"
  else
    family = "fedora"
  end
  package "groonga-release" do
    provider("rpm")
    base_url = "http://packages.groonga.org/#{family}"
    source("#{base_url}/groonga-release-1.1.0-1.noarch.rpm")
  end
end
