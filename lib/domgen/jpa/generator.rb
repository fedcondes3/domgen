module Domgen
  module Generator
    module JPA
      TEMPLATE_DIRECTORY = "#{File.dirname(__FILE__)}/templates"
      FACETS = [:jpa, :sql]
      HELPERS = [Domgen::JPA::Helper, Domgen::Java::Helper]
    end

    def self.define_jpa_model_templates
      [
        Template.new(JPA::FACETS,
                     :enumeration,
                     "#{JPA::TEMPLATE_DIRECTORY}/enum.erb",
                     'java/#{enumeration.jpa.qualified_enumeration_name.gsub(".","/")}.java',
                     JPA::HELPERS),
        Template.new(JPA::FACETS,
                     :entity,
                     "#{JPA::TEMPLATE_DIRECTORY}/model.erb",
                     'java/#{entity.jpa.qualified_entity_name.gsub(".","/")}.java',
                     JPA::HELPERS,
                     'entity.jpa.persistent?'),
        Template.new(JPA::FACETS,
                     :entity,
                     "#{JPA::TEMPLATE_DIRECTORY}/metamodel.erb",
                     'java/#{entity.jpa.qualified_metamodel_name.gsub(".","/")}.java',
                     JPA::HELPERS,
                     'entity.jpa.persistent?'),
      ]
    end

    def self.define_jpa_model_catalog_templates
      [
        Template.new(JPA::FACETS,
                     :data_module,
                     "#{JPA::TEMPLATE_DIRECTORY}/catalog.erb",
                     'java/#{data_module.jpa.qualified_catalog_name.gsub(".","/")}.java'),
      ]
    end

    def self.define_jpa_ejb_templates
      [
        Template.new(JPA::FACETS,
                     :entity,
                     "#{JPA::TEMPLATE_DIRECTORY}/ejb.erb",
                     'java/#{entity.jpa.qualified_dao_name.gsub(".","/")}.java',
                     JPA::HELPERS,
                     'entity.jpa.persistent?')
      ]
    end
  end
end
