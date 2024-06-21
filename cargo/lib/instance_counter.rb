module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def instances
      @instances ||= 0
    end

    def increment_instances
      @instances = instances + 1
    end
  end

  module InstanceMethods
    private

    def register_instance
      self.class.increment_instances
    end
  end
end
