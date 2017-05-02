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
#

Domgen::Generator.define([:gwt_rpc],
                         "#{File.dirname(__FILE__)}/templates",
                         [Domgen::Java::Helper]) do |g|
  g.template_set(:gwt_rpc_shared_service) do |template_set|
    template_set.erb_template(:service,
                              'rpc_service.java.erb',
                              'main/java/#{service.gwt_rpc.qualified_rpc_service_name.gsub(".","/")}.java')
    template_set.erb_template(:service,
                              'async_rpc_service.java.erb',
                              'main/java/#{service.gwt_rpc.qualified_async_rpc_service_name.gsub(".","/")}.java')
    template_set.erb_template(:exception,
                              'exception.java.erb',
                              'main/java/#{exception.gwt_rpc.qualified_name.gsub(".","/")}.java')
  end

  g.template_set(:gwt_rpc_client_service) do |template_set|
    template_set.erb_template(:repository,
                              'rpc_request_builder.java.erb',
                              'main/java/#{repository.gwt_rpc.qualified_rpc_request_builder_name.gsub(".","/")}.java',
                              :guard => 'repository.imit?')
    template_set.erb_template(:repository,
                              'keycloak_rpc_request_builder.java.erb',
                              'main/java/#{repository.gwt_rpc.qualified_keycloak_rpc_request_builder_name.gsub(".","/")}.java',
                              :guard => 'repository.keycloak? && repository.gwt_rpc.secure_services?')
    template_set.erb_template(:repository,
                              'rpc_services_module.java.erb',
                              'main/java/#{repository.gwt_rpc.qualified_rpc_services_module_name.gsub(".","/")}.java')
    template_set.erb_template(:service,
                              'facade_service.java.erb',
                              'main/java/#{service.gwt_rpc.qualified_facade_service_name.gsub(".","/")}.java')
    template_set.erb_template(:service,
                              'proxy.java.erb',
                              'main/java/#{service.gwt_rpc.qualified_proxy_name.gsub(".","/")}.java')
    template_set.erb_template(:repository,
                              'async_callback_adapter.java.erb',
                              'main/java/#{repository.gwt_rpc.qualified_async_callback_adapter_name.gsub(".","/")}.java')
  end
  g.template_set(:gwt_rpc_test_module) do |template_set|
    template_set.erb_template(:repository,
                              'mock_services_module.java.erb',
                              'test/java/#{repository.gwt_rpc.qualified_mock_services_module_name.gsub(".","/")}.java')
  end

  g.template_set(:gwt_rpc_module) do |template_set|
    template_set.erb_template(:repository,
                              'mock_services_module.java.erb',
                              'main/java/#{repository.gwt_rpc.qualified_mock_services_module_name.gsub(".","/")}.java')
  end

  g.template_set(:gwt_rpc_server_service) do |template_set|
    template_set.erb_template(:service,
                              'servlet.java.erb',
                              'main/java/#{service.gwt_rpc.qualified_servlet_name.gsub(".","/")}.java',
                              :additional_facets => [:ejb])
  end

  g.template_set(:gwt_rpc_shared => [:gwt_rpc_shared_service])
  g.template_set(:gwt_rpc_client => [:gwt_rpc_client_service, :gwt_rpc_test_module, :gwt_client_jso])
  g.template_set(:gwt_rpc_server => [:gwt_rpc_server_service])
  g.template_set(:gwt_rpc => [:gwt_rpc_shared, :gwt_rpc_client, :gwt_rpc_server])
end
