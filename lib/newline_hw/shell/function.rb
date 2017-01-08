module NewlineHw
  module Shell
    ##
    # Produce a bash / zsh function to be called by a tty compatible shell
    module Function
      HW_FUNCTION = "hw".freeze

      module_function

      def path
        File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "exe", "newline_hw"))
      end

      def cmd
        <<-eos
function #{HW_FUNCTION}() {

  setup_command=$(#{path} setup_command $*);
  setup_es=$?;

  if [ "$setup_es" = "0" ]; then
    eval $setup_command;
    setup_command_es=$?;

    run_command=$(#{path} run_command $PWD $*);
    run_es=$?;

    if [ $run_es = "0" ] && [ $setup_command_es = "0" ]; then
      eval $run_command;
    else
      echo "Could not run project run command";
      echo $run_command;
    fi
  else
    echo "Could not run project setup command";
    echo $setup_command;
  fi
}
eos
      end
    end
  end
end
