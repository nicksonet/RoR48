# frozen_string_literal: true

require_relative 'train'
require_relative 'passenger_carriage'

class PassengerTrain < Train
  protected

  def attachable_carriage?(carriage)
    carriage.is_a?(PassengerCarriage)
  end
end
