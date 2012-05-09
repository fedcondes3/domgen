module Domgen
  module Generator
    module GWT
      TEMPLATE_DIRECTORY = "#{File.dirname(__FILE__)}/templates"
      FACETS = [:gwt]
      HELPERS = [Domgen::Java::Helper]
    end
  end
end
Domgen.template_set(:gwt_shared_service) do |template_set|
  template_set.template(Domgen::Generator::GWT::FACETS,
                        :service,
                        "#{Domgen::Generator::GWT::TEMPLATE_DIRECTORY}/rpc_service.java.erb",
                        'java/#{service.gwt.qualified_service_name.gsub(".","/")}.java',
                        Domgen::Generator::GWT::HELPERS)
  template_set.template(Domgen::Generator::GWT::FACETS,
                        :exception,
                        "#{Domgen::Generator::GWT::TEMPLATE_DIRECTORY}/exception.java.erb",
                        'java/#{exception.gwt.qualified_name.gsub(".","/")}.java',
                        Domgen::Generator::GWT::HELPERS)
  template_set.template(Domgen::Generator::GWT::FACETS,
                        :service,
                        "#{Domgen::Generator::GWT::TEMPLATE_DIRECTORY}/async_rpc_service.java.erb",
                        'java/#{service.gwt.qualified_async_rpc_service_name.gsub(".","/")}.java',
                        Domgen::Generator::GWT::HELPERS)
end

Domgen.template_set(:gwt_client_service) do |template_set|
  template_set.template(Domgen::Generator::GWT::FACETS,
                        :repository,
                        "#{Domgen::Generator::GWT::TEMPLATE_DIRECTORY}/rpc_services_module.java.erb",
                        'java/#{repository.gwt.qualified_rpc_services_module_name.gsub(".","/")}.java',
                        Domgen::Generator::GWT::HELPERS)
  template_set.template(Domgen::Generator::GWT::FACETS,
                        :message,
                        "#{Domgen::Generator::GWT::TEMPLATE_DIRECTORY}/event.java.erb",
                        'java/#{message.gwt.qualified_event_name.gsub(".","/")}.java',
                        Domgen::Generator::GWT::HELPERS)
  template_set.template(Domgen::Generator::GWT::FACETS,
                        :message,
                        "#{Domgen::Generator::GWT::TEMPLATE_DIRECTORY}/event_handler.java.erb",
                        'java/#{message.gwt.qualified_event_handler_name.gsub(".","/")}.java',
                        Domgen::Generator::GWT::HELPERS)
  template_set.template(Domgen::Generator::GWT::FACETS,
                        :struct,
                        "#{Domgen::Generator::GWT::TEMPLATE_DIRECTORY}/struct_interface.java.erb",
                        'java/#{struct.gwt.qualified_name.gsub(".","/")}.java',
                        Domgen::Generator::GWT::HELPERS)
  template_set.template(Domgen::Generator::GWT::FACETS,
                        :struct,
                        "#{Domgen::Generator::GWT::TEMPLATE_DIRECTORY}/java_struct.java.erb",
                        'java/#{struct.gwt.qualified_java_name.gsub(".","/")}.java',
                        Domgen::Generator::GWT::HELPERS)
  template_set.template(Domgen::Generator::GWT::FACETS + [:json],
                        :struct,
                        "#{Domgen::Generator::GWT::TEMPLATE_DIRECTORY}/struct_factory.java.erb",
                        'java/#{struct.gwt.qualified_factory_name.gsub(".","/")}.java',
                        Domgen::Generator::GWT::HELPERS)
  template_set.template(Domgen::Generator::GWT::FACETS + [:json],
                        :struct,
                        "#{Domgen::Generator::GWT::TEMPLATE_DIRECTORY}/jso_struct.java.erb",
                        'java/#{struct.gwt.qualified_jso_name.gsub(".","/")}.java',
                        Domgen::Generator::GWT::HELPERS)
  template_set.template(Domgen::Generator::GWT::FACETS,
                        :enumeration,
                        "#{Domgen::Generator::GWT::TEMPLATE_DIRECTORY}/enumeration.java.erb",
                        'java/#{enumeration.gwt.qualified_name.gsub(".","/")}.java',
                        Domgen::Generator::GWT::HELPERS)
  template_set.template(Domgen::Generator::GWT::FACETS,
                        :service,
                        "#{Domgen::Generator::GWT::TEMPLATE_DIRECTORY}/facade_service.java.erb",
                        'java/#{service.gwt.qualified_facade_service_name.gsub(".","/")}.java',
                        Domgen::Generator::GWT::HELPERS)
  template_set.template(Domgen::Generator::GWT::FACETS,
                        :service,
                        "#{Domgen::Generator::GWT::TEMPLATE_DIRECTORY}/proxy.java.erb",
                        'java/#{service.gwt.qualified_proxy_name.gsub(".","/")}.java',
                        Domgen::Generator::GWT::HELPERS)
  template_set.template(Domgen::Generator::GWT::FACETS,
                        :repository,
                        "#{Domgen::Generator::GWT::TEMPLATE_DIRECTORY}/services_module.java.erb",
                        'java/#{repository.gwt.qualified_services_module_name.gsub(".","/")}.java',
                        Domgen::Generator::GWT::HELPERS)
end
Domgen.template_set(:gwt_client_service_test) do |template_set|
  template_set.template(Domgen::Generator::GWT::FACETS,
                        :repository,
                        "#{Domgen::Generator::GWT::TEMPLATE_DIRECTORY}/mock_services_module.java.erb",
                        'test/#{repository.gwt.qualified_mock_services_module_name.gsub(".","/")}.java',
                        Domgen::Generator::GWT::HELPERS)
end

Domgen.template_set(:gwt_server_service) do |template_set|
  template_set.template(Domgen::Generator::GWT::FACETS + [:ejb],
                        :service,
                        "#{Domgen::Generator::GWT::TEMPLATE_DIRECTORY}/servlet.java.erb",
                        'java/#{service.gwt.qualified_servlet_name.gsub(".","/")}.java',
                        Domgen::Generator::GWT::HELPERS)
end
