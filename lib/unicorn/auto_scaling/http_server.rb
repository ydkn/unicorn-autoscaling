module Unicorn
  module AutoScaling
    # Auto scaling extensions for the Unicorn http server
    module HttpServer
      RAINDROP_OFFSET = Unicorn::Worker::PER_DROP - 1

      NONE      = 0
      INCREMENT = 1
      DECREMENT = 2

      attr_accessor :autoscaling, :autoscale_idle_time_samples,
                    :autoscale_check_interval, :autoscale_idle_time_decrement,
                    :autoscale_idle_time_increment, :autoscale_min_workers,
                    :autoscale_max_workers

      def process_client(client)
        autoscale! if self.autoscaling

        super(client)

        @_autoscale_time_of_last_request = Time.now.to_f if self.autoscaling
      end

      def reap_all_workers
        if @_autoscale_last_scaling < Time.now.to_f - 10
          if @_autoscale_raindrop[RAINDROP_OFFSET] == INCREMENT
            if self.worker_processes < self.autoscale_max_workers
              logger.info("Auto scaling: UP")

              self.worker_processes += 1
            else
              logger.warn('Auto scaling: Unable to scale up since maximum number of workers already reached!')
            end
          elsif @_autoscale_raindrop[RAINDROP_OFFSET] == DECREMENT
            if self.worker_processes > self.autoscale_min_workers
              logger.info('Auto scaling: DOWN')

              self.worker_processes -= 1
            else
              logger.warn('Auto scaling: Unable to scale down since minimum number of workers already reached!')
            end
          end

          @_autoscale_raindrop[RAINDROP_OFFSET] = NONE

          @_autoscale_last_scaling = Time.now.to_f
        end

        super
      end

      def init_worker_process(worker)
        @_autoscale_time_of_last_request = Time.now.to_f
        @_autoscale_last_check           = Time.now.to_f
        @_autoscale_idle_times           = []

        super(worker)
      end

      def start
        self.autoscale_max_workers ||= self.worker_processes

        super
      end

      private

      def autoscale!
        # Only clear idle times if scaling is requested
        unless @_autoscale_raindrop[RAINDROP_OFFSET] == NONE
          @_autoscale_idle_times.clear

          return
        end

        average_idle_time = autoscale_average_idle_time

        return unless @_autoscale_last_check < Time.now.to_f - self.autoscale_check_interval

        update_autoscale_action_if_necessary(average_idle_time)

        @_autoscale_last_check = Time.now.to_f
      end

      def autoscale_average_idle_time
        idle_time = Time.now.to_f - @_autoscale_time_of_last_request

        @_autoscale_idle_times.unshift(idle_time)

        @_autoscale_idle_times = @_autoscale_idle_times[0..self.autoscale_idle_time_samples]

        @_autoscale_idle_times.inject(:+) / @_autoscale_idle_times.count
      end

      def update_autoscale_action_if_necessary(average_idle_time)
        if average_idle_time < self.autoscale_idle_time_decrement
          update_autoscale_action(INCREMENT)
        elsif average_idle_time > self.autoscale_idle_time_increment
          update_autoscale_action(DECREMENT)
        end
      end

      def update_autoscale_action(action)
        @_autoscale_raindrop[RAINDROP_OFFSET] = action

        @_autoscale_idle_times.clear
      end

      def self.extend_instance!(s)
        s.extend(self)

        s.instance_variable_set(:@_autoscale_raindrop, Raindrops.new(Unicorn::Worker::PER_DROP))
        s.instance_variable_set(:@_autoscale_last_scaling, Time.now.to_f)
      end
    end
  end
end
