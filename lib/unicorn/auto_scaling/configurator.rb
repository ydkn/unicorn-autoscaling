module Unicorn
  module AutoScaling
    # Auto scaling options for the Unicorn::Configurator
    module Configurator
      DEFAULTS = {
        autoscaling: false,
        autoscale_idle_time_decrement: 60,
        autoscale_idle_time_increment: 10,
        autoscale_idle_time_samples: 50,
        autoscale_check_interval: 30,
        autoscale_min_workers: 1,
        autoscale_max_workers: nil
      }
      Unicorn::Configurator::DEFAULTS.merge!(DEFAULTS)

      # enables autoscaling if set to true or disables it otherwise
      def autoscaling(value)
        set_bool(:autoscaling, value)
      end

      # sets the time minimum average idle time
      # before a worker decrement is performed
      def autoscale_idle_time_decrement(value)
        set_int(:autoscale_idle_time_decrement, value, 1)
      end

      # sets the time maximum average idle time
      # before a worker increment is performed
      def autoscale_idle_time_increment(value)
        set_int(:autoscale_idle_time_increment, value, 1)
      end

      # sets the amount of requests used to calculate
      # the average idle time
      def autoscale_idle_time_samples(value)
        set_int(:autoscale_idle_time_samples, value, 1)
      end

      # sets the interval for checking if scaling
      # should be performed
      def autoscale_check_interval(value)
        set_int(:autoscale_check_interval, value, 1)
      end

      # sets the minimum number of worker processes
      def autoscale_min_workers(value)
        set_int(:autoscale_min_workers, value, 1)
      end

      # sets the maximum number of worker processes
      def autoscale_max_workers(value)
        set_int(:autoscale_max_workers, value, 1)
      end

      def self.extend_instance!(c)
        c.extend(self)

        c.set.merge!(DEFAULTS)
      end
    end
  end
end
