# frozen_string_literal: true

class BaseChecker
  attr_reader :all_locales

  def initialize(all_locales)
    @all_locales = all_locales
  end

  def report
    raise 'You must define a `report` method in the child class!'
  end
end
