module Oplop
  module Cli
   
    def self.banner
      "Usage: oplop [OPTIONS] [label]"
    end

    def self.help
      help = <<-HELP
This is a simple cli program to generate oplop passwords.

You will be prompted for your master password.  

The default behavior is to copy the password to your clipboard, and
not display it.  This works if you are on a Mac (and/or have pbcopy 
installed), or if you have xclip (installed for Linux).

If you do not have pbcopy or xclip, you will have to run the program
in verbose mode (--verbose).

Here are some examples:

Copy my github password to clipboard:
  oplop github

Print my gmail password to STDOUT.
  oplop --verbose gmail

Copy a new password for amazon (prompts for master twice):
  oplop --new amazon

Feedback, patches and bugs: https://github.com/bkaney/oplop
HELP
    end

    def self.copy_to_clipboard(string)
      if (copy_program = `which pbcopy`) && !copy_program.empty?
        system("echo #{string} | #{copy_program}")
      elsif (copy_program = `which xclip`) && !copy_program.empty?
        system("echo #{string} | #{copy_program}")
      end
    end
    
  end
end