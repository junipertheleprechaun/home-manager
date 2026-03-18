hostList: let
  defaults = {
    extraOptions = {
      ForwardAgent = "yes";
    };
  };
  tmux =
    defaults
    // {
      extraOptions =
        {
          # automatically launch TMUX if it exists
          RemoteCommand = "bash -l -c 'tmux attach-session || tmux new-session'";
          RequestTTY = "yes";
          #SetEnv = "TERM=xterm-256color";
        }
        // defaults.extraOptions;
    };
in
  builtins.listToAttrs (
    builtins.attrValues (
      builtins.mapAttrs (name: value: {
        name = name + ".raw";
        value = value // defaults;
      })
      hostList
    )
  )
  // (
    builtins.mapAttrs (name: value: value // tmux) hostList
  )
