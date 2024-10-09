{
  description = "Nix flake for R publishing development";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # Base packages
        basePackages = with pkgs; [
          bashInteractive
          gettext
          gh
          git
          pandoc
          quarto
          R
          radianWrapper
        ];

        # R packages
        rPackages = with pkgs.rPackages; [
          # Utils
          devtools
          knitr
          languageserver
          pak
          renv
          rlang
          rmarkdown
          usethis
          # Project
          bslib
          corpora
          downlit
          fontawesome
          ggrepel
          glmnet
          gutenbergr
          infer
          janitor
          kableExtra
          pacman
          PsychWordVec
          quanteda
          scales
          skimr
          stopwords
          textrecipes
          textstem
          tidymodels
          tidyverse
          tinytable
          webexercises
        ];

        # Texlive packages
        texlivePackages = with pkgs; [
          (texlive.combine {
            inherit (texlive) scheme-small
              # Add texlive packages here

              ;
          })
        ];

        allPackages = basePackages ++ rPackages ++ texlivePackages;
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = allPackages;
          shellHook = ''
            export R_LIBS_USER=$PWD/R/Library; mkdir -p $R_LIBS_USER;
          '';
        };
      });
}
