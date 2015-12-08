#
# Cookbook Name:: timmy
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe "apt::default"
include_recipe "apache2::default"
include_recipe "apache2::mod_mpm_prefork"
#include_recipe "apache2::mod_wsgi"
