# frozen_string_literal: true

module RailsTranslationManager
  class Cleaner
    def initialize(path)
      @path = path
    end

    def clean
      `find #{@path} -type f -exec perl -p -i -e \"s/[ \t]$//g\" {} \\;`
    end
  end
end
