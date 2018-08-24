#
# Cookbook:: web-app
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
#
package "httpd" do
        action [:install]
end

package "mod_ssl" do
        action [:install]
end

service "iptables" do
        action [:disable,:stop]
end

service "ip6tables" do
        action [:disable,:stop]
end

directory "#{node['apache']['dir']}/ssl" do
        action :create
        recursive true
        mode 0755
end

remote_directory "#{node['apache']['dir']}/ssl" do
        source "certificates"
        files_owner "root"
        files_group "root"
        files_mode 00644
        owner "root"
        group "root"
        mode 0755
end

template "/etc/httpd/conf.d/ssl.conf" do
        source "ssl.conf.erb"
        mode 0644
        owner "root"
        group "root"
        variables(
                :sslcertificate => "#{node['apache']['sslpath']}/chef_sanketdangi_com.crt",
                :sslkey => "#{node['apache']['sslpath']}/chef.sanketdangi.com.key",
                :sslcacertificate => "#{node['apache']['sslpath']}/chef_sanketdangi_com.ca-bundle",
                :servername => "#{node['apache']['servername']}"
        )
end

execute "change_for_selinux" do
        command "chcon -Rv --type=httpd_sys_content_t /etc/httpd/ssl/"
        action :run
end

service "httpd" do
    action [:enable,:start]
end

