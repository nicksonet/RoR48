class Route
    attr_reader :stations

    def initialize(start_station, end_station)
      @stations = [start_station, end_station]
    end

    def add_station(station)
      @stations.insert(-2, station)
    end

    def remove_station(station)
      @stations.delete(station) if station != @stations.first && station != @stations.last
    end

    def print_stations
      @stations.each { |station| puts station.name }
    end
  end
