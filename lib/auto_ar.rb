require 'active_support'
require 'active_record'

if defined?(ActiveRecord::Base)
  module AutoAR
    def self.included(base)
      base.class_eval do
        unless defined? const_missing_without_auto_ar
          alias_method_chain :const_missing, :auto_ar
        end
      end
    end
    def const_missing_with_auto_ar(const_name)
      begin
        const_missing_without_auto_ar(const_name)
      rescue NameError => e
        begin
          conn = ActiveRecord::Base.connection
          if conn.tables.include?(const_name.to_s.tableize)
            Object.const_set(const_name, Class.new(ActiveRecord::Base))
          else
            raise NameError
          end
        rescue ActiveRecord::ConnectionNotEstablished, ActiveRecord::StatementInvalid
          raise NameError
        end
      end
    end
  end

  module AutoARReflection
    def self.included(base)
      base.class_eval do
        unless defined? method_missing_without_auto_ar
          alias_method_chain :method_missing, :auto_ar
        end
      end
    end

    def method_missing_with_auto_ar(method_sym, *args)
      begin
        method_missing_without_auto_ar(method_sym, *args)
      rescue NoMethodError => e
        method_name = method_sym.to_s
        if method_name == method_name.singularize
          f_key = method_name.singularize.foreign_key
          if self.respond_to?(f_key)
            target_klass = Object.const_get(method_name.classify)
            target_klass.class_eval("has_many :#{self.class.to_s.pluralize.underscore}")
            self.class.class_eval("belongs_to :#{method_sym}")
          else
            raise NoMethodError
          end
        elsif method_name == method_name.pluralize
          table_name = method_name.tableize
          f_key = self.class.to_s.foreign_key
          conn = self.connection
          if conn.tables.include?(table_name) &&
              conn.columns(table_name).map(&:name).include?(f_key)
            target_klass = Object.const_get(method_name.classify)
            target_klass.class_eval("belongs_to :#{self.class.to_s.singularize.underscore}")
            self.class.class_eval("has_many :#{method_sym}")
          else
            raise NoMethodError
          end
        else
          raise NoMethodError
        end
        self.send(method_sym, *args)
      end
    end
  end
  Module.instance_eval{ include AutoAR }
  ActiveRecord::Base.instance_eval{ include AutoARReflection }
else
  raise "Error: ActiveRecord required."
end

