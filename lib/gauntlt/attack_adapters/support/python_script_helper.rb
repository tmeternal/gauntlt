# TODO: get this explicit require to work
# require 'gauntlt/support/cli_helper'

module Gauntlt
  module Support
    module PythonScriptHelper
      DOWNLOAD_URLS = {
        'sslyze' => 'https://github.com/iSECPartners/sslyze',
        'sqlmap' => 'https://github.com/sqlmapproject/sqlmap'
      }

      def python_installed?
        cli_installed?('python')
      end

      def shell_variable_name_for(script_name)
        script_name.upcase + '_PATH'
      end

      def path_to_python_script(shell_variable_name)
        ENV[shell_variable_name]
      end

      def script_exists?(script_name)
        shell_variable_name = shell_variable_name_for(script_name)
        path = path_to_python_script(shell_variable_name)
        File.exists?(path) if path
      end

      def python_script_installed?(script_name)
        python_installed? && script_exists?(script_name)
      end

      def ensure_python_script_installed(script_name)
        python_script_installed?(script_name) || begin
          shell_variable_name = '$' + shell_variable_name_for(script_name)

          msg = <<-EOS
    #{script_name}.py not installed or #{shell_variable_name} not set!

    1. Download #{script_name} from: #{DOWNLOAD_URLS[script_name]}
    2. In your .zshrc or .bash_profile (or whatever), set #{shell_variable_name}

       export #{shell_variable_name.gsub('$', '')}=/path/to/#{script_name}.py

    3. Make sure you have python installed:

       $ which python


EOS

          raise msg

        end
      end
    end
  end
end
World(Gauntlt::Support::PythonScriptHelper)