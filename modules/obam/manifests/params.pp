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

class obam::params inherits ob_common::params{

  $start_script_template  = 'bin/api-manager.sh'

  # Maximum and minimum memory sizes for JVM
  $jvmxms = '2048m'
  $jvmxmx = '2048m'

  # Template list
  $template_list = ['repository/conf/deployment.toml']

  # Define file list
  $file_list = ['repository/deployment/server/synapse-configs/default/sequences/_cors_request_handler_.xml']

  # Define remove file list
  $file_removelist = []
}
