# frozen_string_literal: true

desc "Prints the number of lines of .rb files which contains a Solid::Process"
namespace :solid do
  task :processes do
    system(<<~SHELL)
      cd #{Rails.root}  \
      && printf 'Lines:\\n' \
      && grep --include *.rb -REl '<.+Solid::Process' . \
      | xargs wc -l  \
      | tee /dev/tty \
      | wc -l        \
      | awk '{printf "\\nFiles: %s\\n",$1-1}'
    SHELL
  end
end
