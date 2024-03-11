let
    pkgs = import <unstable> { };
    lib = pkgs.lib;
    stdenv = pkgs.stdenv;
in pkgs.mkShell {
    buildInputs = with pkgs; [
        python312
        poetry
        awscli2
    ];
    shellHook =
    ''
        export RENV_PATHS_LIBRARY=renv/library;
        export PYTHONPATH=$PYTHONPATH:$(pwd);
        export GEOMATCH_VERSION=dev;
        alias poe="poetry run poe";
        alias rge="rg -g '!{**/migrations/*.py,**/node_modules/**,**/*.json,**/*.csv}'";
        alias rger="rg -g '!{**/migrations/*.py,**/node_modules/**,**/*.json,**/*.csv,**/*.R}'";
        alias rgr="rg --hidden -g '**/api/core/rcode_pilot/**/*.R'";
        alias rgpy="rg --hidden -g '**/*.py'";
        # Source env vars from env file:
        while IFS= read -r line; do
            # Skip empty lines and lines starting with #
            if [[ ! -z "$line" && ! "$line" =~ ^# ]]; then
                export "$line"
            fi
        done < .env.development
    '';
}