#----------------------------------------------------------------------------
#  Copyright (c) 2019 WSO2, Inc. http://www.wso2.org
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#----------------------------------------------------------------------------

class obiam inherits obiam::params {

  include ob_common

  # Copy deployment.toml to installed directory
  file { "${carbon_home}/${toml_file_path}/${toml_file_name}":
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/carbon-home/${toml_file_path}/${toml_file_name}.erb"),
    notify  => Service["${wso2_service_name}"],
    require => Class["ob_common"]
  }

  # Copy iskm connector script to installed directory
  file { "${carbon_home}/${accelerator_pack}/bin/merge-connector.sh":
    ensure  => file,
    mode    => '0755',
    source => "puppet:///modules/${module_name}/merge-connector.sh",
    notify  => Service["${wso2_service_name}"],
    require => Class["ob_common"]
  }

  # Merge iskm connector
  exec { "merge-iskm-connector":
    command => "${product_dir}/${pack}/${accelerator_pack}/bin/merge-connector.sh",
    user    => $user,
    group   => $user_group,
    cwd     => "${product_dir}/${pack}/${accelerator_pack}/bin",
  }

  # Copy configuration changes to the installed directory
  $template_list.each |String $template| {
    file { "${carbon_home}/${template}":
      ensure  => file,
      mode    => '0644',
      content => template("${module_name}/carbon-home/${template}.erb"),
      notify  => Service["${wso2_service_name}"],
      require => Class["ob_common"]
    }
  }

  # Copy files to carbon home directory
  $file_list.each | String $file | {
    file { "${carbon_home}/${file}":
      ensure  => present,
      owner   => $user,
      recurse => remote,
      group   => $user_group,
      mode    => '0755',
      source  => "puppet:///modules/${module_name}/${file}",
      notify  => Service["${wso2_service_name}"],
      require => Class["ob_common"]
    }
  }

  # Delete files to carbon home directory
  $file_removelist.each | String $removefile | {
    file { "${carbon_home}/${removefile}":
      ensure => absent,
      owner => $user,
      group => $user_group,
      notify  => Service["${wso2_service_name}"],
      require => Class["ob_common"]
    }
  }

  # Copy wso2server.sh to installed directory
  file { "${carbon_home}/${start_script_template}":
    ensure  => file,
    owner   => $user,
    group   => $user_group,
    mode    => '0754',
    content => template("${module_name}/carbon-home/${start_script_template}.erb"),
    notify  => Service["${wso2_service_name}"],
    require => Class["ob_common"]
  }
}
