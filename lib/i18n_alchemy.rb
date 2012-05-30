require "date"
require "active_record"
require "i18n"
require "i18n_alchemy/date_parser"
require "i18n_alchemy/time_parser"
require "i18n_alchemy/numeric_parser"
require "i18n_alchemy/attribute"
require "i18n_alchemy/association_parser"
require "i18n_alchemy/attributes_parsing"
require "i18n_alchemy/proxy"

module I18n
  module Alchemy
    extend ActiveSupport::Concern

    def localized(attributes=nil, *args)
      I18n::Alchemy::Proxy.new(self, attributes, *args)
    end

    included do
      class_attribute :localized_methods,
        :instance_reader => false, :instance_writer => false
      self.localized_methods = {}

      class_attribute :customized_parsers,
        :instance_reader => false, :instance_writer => false
      self.customized_parsers = {}
    end

    module ClassMethods
      def localize(*methods, options)
        parser  = options[:using]
        methods = methods.each_with_object(localized_methods) do |method_name, hash|
          hash[method_name] = parser
        end
        self.localized_methods = methods
      end

      def custom_parsers(parsers_hash)
        self.customized_parsers = self.customized_parsers.merge(parsers_hash)
      end
    end
  end
end
