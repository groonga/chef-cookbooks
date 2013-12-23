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

  apt_repository "groonga" do
    extend Chef::Mixin::ShellOut

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

    uri "http://packages.groonga.org/#{platform}/"
    distribution code_name
    components [component]
    keyserver "keyserver.ubuntu.com"
    key "45499429"
  end
elsif platform_family?("rhel", "fedora")
  if platform_family?("rhel")
    family = "centos"
  else
    family = "fedora"
  end

  rpm_base_name = "groonga-release-1.1.0-1.noarch.rpm"
  cached_rpm_path = "#{Chef::Config[:file_cache_path]}/#{rpm_base_name}"
  remote_file cached_rpm_path do
    base_url = "http://packages.groonga.org/#{family}"
    source "#{base_url}/#{rpm_base_name}"
    not_if "rpm -qa | egrep -qx 'groonga-release-1.1.0-1(|.noarch)'"
    notifies :install, "rpm_package[groonga-release]", :immediately
  end

  rpm_package "groonga-release" do
    source cached_rpm_path
    only_if {::File.exists?(cached_rpm_path)}
    action :nothing
  end

  file "groonga-release-cleanup" do
    path cached_rpm_path
    action :delete
  end
end
