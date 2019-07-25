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

module Domgen #nodoc
  module ModelChecks #nodoc
    class << self
      def name_check(repository)
        repository.model_check(:Names) do |mc|
          mc.check = Proc.new do |r|
            #TODO: Autogenerated this based on facet metadata
            check_name(r, 'Repository', r)

            if r.jms?
              r.jms.destinations.each do |d|
                check_name(r, 'JMS Destination', d)
              end
            end

            if r.gwt?
              r.gwt.entrypoints.each do |e|
                check_name(r, 'GWT Entrypoint', e)
              end
            end

            if r.jpa?
              r.jpa.standalone_persistence_units.each do |p|
                check_name(r, 'JPA Persistence Unit', p)
              end
            end

            r.data_modules.each do |data_module|
              check_name(r, 'Data Module', data_module)

              data_module.enumerations.each do |enumeration|
                check_name(r, 'Enumeration', enumeration)

                #TODO: Verify enumeration_values are constant cased?
              end

              data_module.structs.each do |struct|
                check_name(r, 'Struct', struct)
                struct.fields.each do |field|
                  check_name(r, 'Field', field)
                  check_no_dto_suffix('Field', field)
                end
              end

              data_module.entities.each do |entity|
                check_name(r, 'Entity', entity)
                entity.attributes.each do |attribute|
                  check_name(r, 'Attribute', attribute)
                end
              end

              data_module.remote_entities.each do |entity|
                check_name(r, 'Remote Entity', entity)
                entity.attributes.each do |attribute|
                  check_name(r, 'Attribute', attribute)
                end
              end

              data_module.daos.each do |dao|
                check_name(r, 'Data Access Object', dao)
                dao.queries.each do |query|
                  check_name(r, 'Query', query)
                  query.parameters.each do |parameter|
                    check_name(r, 'Query Parameter', parameter)
                    check_no_dto_suffix('Query Parameter', parameter)
                  end
                end
              end

              data_module.services.each do |service|
                check_name(r, 'Service', service)
                service.methods.each do |method|
                  check_name(r, 'Method', method)
                  method.parameters.each do |parameter|
                    check_name(r, 'Method Parameter', parameter)
                    check_no_dto_suffix('Method Parameter', parameter)
                  end
                end
              end

              data_module.messages.each do |message|
                check_name(r, 'Message', message)
                message.parameters.each do |parameter|
                  check_name(r, 'Message Parameter', parameter)
                  check_no_dto_suffix('Message Parameter', parameter)
                end
              end

              data_module.exceptions.each do |exception|
                check_name(r, 'Exception', exception)
                exception.parameters.each do |parameter|
                  check_name(r, 'Exception Parameter', parameter)
                  check_no_dto_suffix('Exception Parameter', parameter)
                end
              end
            end
          end
        end
      end

      private

      def check_no_dto_suffix(type, element)
        check_no_suffix(type, element, 'DTO')
        check_no_suffix(type, element, 'VO')
        check_no_suffix(type, element, Reality::Naming.pluralize('DTO'))
        check_no_suffix(type, element, Reality::Naming.pluralize('VO'))
      end

      def check_no_suffix(type, element, suffix)
        Domgen.error("#{type} '#{element.qualified_name}' does not follow naming convention and should not have suffix '#{suffix}'") if element.name.to_s =~ /[a-z0-9_]#{suffix}$/
      end

      def check_name(repository, type, element)
        Domgen.error("#{type} '#{element.respond_to?(:qualified_name) ? element.qualified_name : element.name}' does not follow naming convention and use pascal case name") unless Reality::Naming.pascal_case?(element.name.to_s)
        Domgen.error("#{type} '#{element.respond_to?(:qualified_name) ? element.qualified_name : element.name}' uses 'ID' as a name component but should use 'Id'") if !(repository.application? && repository.application.uppercase_id?) && Reality::Naming.split_into_words(element.name.to_s).include?('ID')
      end
    end
  end
end
