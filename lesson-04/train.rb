class Train
    attr_reader :number, :type, :wagons, :speed, :route

    def initialize(number, type, wagons)
      @number = number
      @type = type
      @wagons = wagons
      @speed = 0
    end

    def accelerate(speed)
      @speed += speed
    end

    def brake
      @speed = 0
    end

    def attach_wagon
      @wagons += 1 if @speed.zero?
    end

    def detach_wagon
      @wagons -= 1 if @speed.zero? && @wagons > 0
    end

    def assign_route(route)
      @route = route
      @current_station_index = 0
      current_station.accept_train(self)
    end

    def go_forward
      return unless next_station

      current_station.send_train(self)
      next_station.accept_train(self)
      @current_station_index += 1
    end

    def go_back
      return unless previous_station

      current_station.send_train(self)
      previous_station.accept_train(self)
      @current_station_index -= 1
    end

    def current_station
      @route.stations[@current_station_index]
    end

    def next_station
      @route.stations[@current_station_index + 1]
    end

    def previous_station
      @route.stations[@current_station_index - 1] if @current_station_index.positive?
    end
  end
