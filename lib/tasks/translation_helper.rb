class TranslationHelper

  def initialize(task_options, locale)
    @task_options = task_options
    @locale = locale
  end

  def with_optional_locale
    @locale ? @task_options << ["-l", @locale] : @task_options
  end
end
