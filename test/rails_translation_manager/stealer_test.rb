require "test_helper"

require "rails_translation_manager/stealer"
require "fileutils"
require "tmpdir"
require "csv"
require "i18n"

module RailsTranslationManager
  class StealerTest < Minitest::Test

    test "converts subtree of items to the same depth" do

      original = {
        "fr" => {
          "document" => {
            "type" => {
              "type1" => 'premier genre',
              "type2" => 'deuxième genre',
              "type3" => 'troisième genre'
            }
          }
        }
      }

      conversion_mapping = {
        "document.type" => "content_item.format",
      }

      expected = {
        "fr" => {
          "content_item" => {
            "format" => {
              "type1" => 'premier genre',
              "type2" => 'deuxième genre',
              "type3" => 'troisième genre'
            }
          }
        }
      }
      stealer_test(original, conversion_mapping, expected)
    end

    test "converts a subtree of items to a different depth" do
      original = {
        "fr" => {
          "document" => {
            "published" => 'publiée',
          }
        }
      }
      conversion_mapping = {
         "document.published" => "content_item.metadata.published"
      }

      expected = {
        "fr" => {
          "content_item" => {
            "metadata" => {
              "published" => 'publiée'
            }
          }
        }
      }

      stealer_test(original, conversion_mapping, expected)
    end

    test "combines multiple mappings" do
      original = {
        "fr" => {
          "document" => {
            "type" => {
              "type1" => 'premier genre',
            },
            "published" => 'publiée',
          }
        }
      }

      conversion_mapping = {
        "document.type" => "content_item.format",
        "document.published" => "content_item.metadata.published"
      }
      expected = {
        "fr" => {
          "content_item" => {
            "format" => {
              "type1" => 'premier genre',
            },
            "metadata" => {
              "published" => 'publiée',
            }
          }
        }
      }
      stealer_test(original, conversion_mapping, expected)
    end

    test "does not copy over keys with no mapping" do
      original = {
        "fr" => {
          "document" => {
            "published" => 'publiée',
            "do_not_want" => 'non voulu'
          }
        }
      }
      conversion_mapping = {
         "document.published" => "content_item.metadata.published"
      }

      expected = {
        "fr" => {
          "content_item" => {
            "metadata" => {
              "published" => 'publiée'
            }
          }
        }
      }

      stealer_test(original, conversion_mapping, expected)
    end

    test "overrides existing translations present in mapping" do
      original = {
        "fr" => {
          "document" => {
            "published" => 'publiée',
            "updated" => 'mise au jour',
          }
        }
      }

      conversion_mapping = {
        "document.published" => "content_item.metadata.published",
        "document.updated" => "content_item.metadata.updated"
      }

      existing = {
        "fr" => {
          "content_item" => {
            "metadata" => {
              "updated" => 'mauvaise traduction'
            }
          }
        }
      }

      expected = {
        "fr" => {
          "content_item" => {
            "metadata" => {
              "published" => 'publiée',
              "updated" => 'mise au jour',
            }
          }
        }
      }
      stealer_test(original, conversion_mapping, expected, existing)
    end

    test "does not override existing translations not in mapping" do
      original = {
        "fr" => {
          "document" => {
            "published" => 'publiée',
          }
        }
      }

      conversion_mapping = {
        "document.published" => "content_item.metadata.published"
      }

      existing = {
        "fr" => {
          "content_item" => {
            "metadata" => {
              "updated" => 'mise au jour',
            }
          }
        }
      }

      expected = {
        "fr" => {
          "content_item" => {
            "metadata" => {
              "published" => 'publiée',
              "updated" => 'mise au jour',
            }
          }
        }
      }
      stealer_test(original, conversion_mapping, expected, existing)
    end

  private

    def stealer_test(original, mapping, expected, existing=nil)
      write_source_data(original)
      write_converter_data(mapping)

      if existing.present?
        File.open(locale_file, 'w') do |f|
          f.puts(existing.to_yaml)
        end
      end

      stealer = RailsTranslationManager::Stealer.new("fr", source_dir, converter_path, locales_dir)
      stealer.steal_locale

      assert_equal expected, YAML.load_file(locale_file)
    end

    def source_dir
      @source_dir ||= Dir.mktmpdir
    end

    def source_locale_path
      File.join(source_dir, 'config/locales')
    end

    def write_source_data(data)
      FileUtils.mkdir_p(source_locale_path)
      File.open(File.join(source_locale_path, 'fr.yml'), 'w') do |f|
        f.puts(data.to_yaml)
      end
    end

    def write_converter_data(data)
      File.open(converter_path, 'w') do |f|
        f.puts(data.to_yaml)
      end
    end

    def converter_path
      @converter_path ||= Tempfile.new('fr').path
    end

    def locales_dir
      @locales_dir ||= Dir.mktmpdir
    end

    def locale_file
      File.join(locales_dir, 'fr.yml')
    end
  end
end
