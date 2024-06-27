# frozen_string_literal: true

require_relative 'train'
require_relative 'cargo_carriage'

class CargoTrain < Train
  protected

  def attachable_carriage?(carriage)
    carriage.is_a?(CargoCarriage)
  end
end
