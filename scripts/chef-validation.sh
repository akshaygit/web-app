#!/bin/bash

#validate Cookbook 

foodcritic /home/ec2-user/chef-repo/cookbooks/web-app

#validate Recipe

ruby -c /home/ec2-user/chef-repo/cookbooks/web-app/recipes/default.rb
