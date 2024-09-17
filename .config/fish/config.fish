if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -g theme_color_scheme nord
set -g theme_powerline_fonts yes
set -g theme_nerd_fonts yes

set -g theme_show_exit_status yes

set -g theme_use_abbreviated_branch_name no
set -g theme_display_git_default_branch yes

function starship_transient_prompt_func
  starship module character
end
function starship_transient_rprompt_func
  starship module time
end
starship init fish | source
enable_transience

set -gx CC clang
set -gx CXX clang++
