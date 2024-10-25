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
          pacman
          pak
          renv
          rlang
          rmarkdown
          usethis
          # Rendering
          downlit
          bslib
          here
          rstudioapi
          # Project
          corpora
          dplyr
          fontawesome
          fs
          GGally
          ggplot2
          ggrepel
          glmnet
          gutenbergr
          infer
          janitor
          kableExtra
          PsychWordVec
          purrr
          quanteda
          # quanteda.corpora
          readr
          reprex
          scales
          skimr
          stringr
          stopwords
          textrecipes
          textstem
          tibble
          tidymodels
          tidyr
          tidytext
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
            export R_LIBS_USER=$PWD/R/Library; mkdir -p "$R_LIBS_USER";
            echo "R environment set up";
          '';
        };
      });
}
