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

module Domgen
  module XML
    def self.include_xml(type, parent_key)
      type.class_eval(<<-RUBY)
      attr_writer :name

      def name
        @name || Reality::Naming.xmlize(#{parent_key}.name)
      end
      RUBY
    end

    def self.include_data_element_xml(type, parent_key)
      type.class_eval(<<-RUBY)
      Domgen::XML.include_xml(self, :#{parent_key})

      attr_writer :component_name

      def component_name
        @component_name || Reality::Naming.xmlize(#{parent_key}.component_name)
      end

      attr_writer :required

      def required?
        @required.nil? ? !#{parent_key}.nullable? : @required
      end

      attr_writer :element

      # default to false for non-collection attributes and true for collection attributes
      def element?
        @element.nil? ? #{parent_key}.collection? || #{parent_key}.struct? : @element
      end
      RUBY
    end
  end

  FacetManager.facet(:xml) do |facet|
    facet.enhance(Repository) do
      Domgen::XML.include_xml(self, :repository)

      attr_writer :local_namespace

      def local_namespace
        @local_namespace || repository.name
      end

      attr_writer :namespace

      def namespace
        @namespace || "#{base_namespace}/#{local_namespace}"
      end

      attr_writer :base_namespace

      def base_namespace
        @base_namespace || 'http://example.com'
      end
    end

    facet.enhance(DataModule) do
      Domgen::XML.include_xml(self, :data_module)

      attr_writer :namespace

      def namespace
        @namespace || "#{data_module.repository.xml.namespace}/#{data_module.name}"
      end

      # xml prefix
      def prefix
        Reality::Naming.underscore(data_module.name)
      end

      def schema_name
        data_module.name
      end

      def xsd_name
        "#{data_module.repository.name}/#{schema_name}.xsd"
      end

      def referenced_data_modules
        data_modules = []

        data_module.structs.select { |e| e.xml? }.each do |struct|
          struct.fields.each do |f|
            if f.struct? && f.xml? && f.referenced_struct.data_module.name != data_module.name
              data_modules << f.referenced_struct.data_module
            elsif f.enumeration? && f.xml? && f.enumeration.data_module.name != data_module.name
              data_modules << f.enumeration.data_module
            end
          end
        end
        data_module.exceptions.select { |e| e.xml? }.each do |exception|
          exception.parameters.each do |p|
            if p.struct? && p.xml? && p.referenced_struct.data_module.name != data_module.name
              data_modules << p.referenced_struct.data_module
            elsif p.enumeration? && p.xml? && p.enumeration.data_module.name != data_module.name
              data_modules << p.enumeration.data_module
            end
          end
        end
        data_module.services.select { |s| s.xml? }.each do |service|
          service.methods.select { |m| m.xml? }.each do |method|
            method.parameters.each do |p|
              if p.struct? && p.xml? && p.referenced_struct.data_module.name != data_module.name
                data_modules << p.referenced_struct.data_module
              elsif p.enumeration? && p.xml? && p.enumeration.data_module.name != data_module.name
                data_modules << p.enumeration.data_module
              end
            end
          end
        end

        data_modules.sort.uniq
      end

      def resource_xsd_name
        "META-INF/xsd/#{xsd_name}"
      end
    end

    facet.enhance(EnumerationSet) do
      Domgen::XML.include_xml(self, :enumeration)

      def namespace
        enumeration.data_module.xml.namespace
      end
    end

    facet.enhance(Parameter) do
      Domgen::XML.include_data_element_xml(self, :parameter)
    end

    facet.enhance(Exception) do
      Domgen::XML.include_xml(self, :exception)

      def namespace
        exception.data_module.xml.namespace
      end
    end

    facet.enhance(ExceptionParameter) do
      Domgen::XML.include_data_element_xml(self, :parameter)

      def pre_complete
        if parameter.struct? && !parameter.referenced_struct.xml? || parameter.enumeration? && !parameter.enumeration.xml?
          parameter.exception.disable_facet(:xml)
        end
      end
    end

    facet.enhance(Struct) do
      Domgen::XML.include_xml(self, :struct)

      # Override name to strip out DTO/VO suffix
      def name
        return @name if @name
        candidate = Reality::Naming.xmlize(struct.name)
        return candidate[0, candidate.size-4] if candidate =~ /-dto$/
        return candidate[0, candidate.size-3] if candidate =~ /-vo$/
        candidate
      end

      def namespace
        struct.data_module.xml.namespace
      end
    end

    facet.enhance(StructField) do
      Domgen::XML.include_data_element_xml(self, :field)

      def pre_complete
        if field.struct? && !field.referenced_struct.xml? || field.enumeration? && !field.enumeration.xml?
          field.exception.disable_facet(:xml)
        end
      end
    end
  end
end
