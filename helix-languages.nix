{ pkgs, ... }:

{
  language-server = {
    marksman = { command = "marksman"; args = ["server"]; };
    tailwindcss-ls = { command = "tailwindcss-language-server"; args = ["--stdio"]; };
    eslint = { command = "vscode-eslint-language-server"; args = ["--stdio"]; };
    nixd = { command = "nixd"; };
    phpactor = { command = "phpactor"; args = ["language-server"]; };
    sqls = { command = "sqls"; };    
    ruff = { command = "ruff"; args = ["server"]; };
    jedi = { command = "jedi-language-server"; };
    vtsls = { command = "vtsls"; args = ["--stdio"]; config.typescript.updateImportsOnFileMove.enabled = "always"; };
    intelephense = { command = "intelephense"; args = ["--stdio"]; config = { storagePath = "/tmp/intelephense"; }; };
  };

  language = [
    { name = "nix"; language-servers = [ "nixd" ]; formatter = { command = "nixpkgs-fmt"; }; auto-format = true; }
    { name = "typescript"; language-servers = [ { name = "vtsls"; } "tailwindcss-ls" "eslint" ]; formatter = { command = "prettier"; args = ["--parser" "typescript"]; }; auto-format = true; }
    { name = "tsx"; language-servers = [ { name = "vtsls"; } "tailwindcss-ls" "eslint" ]; formatter = { command = "prettier"; args = ["--parser" "typescript"]; }; auto-format = true; }
    { name = "javascript"; language-servers = [ { name = "vtsls"; } "tailwindcss-ls" "eslint" ]; formatter = { command = "prettier"; args = ["--parser" "typescript"]; }; auto-format = true; }
    { name = "html"; formatter = { command = "prettier"; args = ["--parser" "html"]; }; auto-format = true; }
    { name = "css"; formatter = { command = "prettier"; args = ["--parser" "css"]; }; auto-format = true; }
    { name = "python"; language-servers = [ "ruff" "jedi" ]; formatter = { command = "ruff"; args = ["format" "-"]; }; auto-format = true; }
    { name = "php"; language-servers = [ "intelephense" "phpactor" ]; formatter = { command = "php-cs-fixer"; args = ["fix" "-" "--rules=@PSR12"]; }; auto-format = true; }
    { name = "markdown"; language-servers = [ "marksman" ]; formatter = { command = "prettier"; args = ["--parser" "markdown"]; }; auto-format = true; }
    { name = "sql"; language-servers = [ "sqls" ]; formatter = { command = "sqlfluff"; args = ["format" "-" "--dialect" "mysql"]; }; auto-format = true; }
  ];
}
