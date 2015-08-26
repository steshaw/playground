with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "ocaml-shell";
  src = null;
#  buildInputs = [ curl darcs git gnum4 mercurial ncurses ocaml opam rsync unzip llvm ];
  buildInputs = [ curl gnum4 ncurses ocaml:4.02 opam rsync unzip llvm ];

  ocamlinit = ./ocamlinit.ml;

  shellHook = ''
    if [ ! -d "$HOME/.opam" ]; then
        echo "n\n"| "${opam}/bin/opam" init
    fi

    echo "Running \". $HOME/.opam/opam-init/init.sh\" ..."
    . "$HOME/.opam/opam-init/init.sh" > /dev/null 2> /dev/null || true

    alias ocaml="ocaml -init $ocamlinit"
    alias utop="utop -init $ocamlinit"

    rebuild () {
        opam reinstall $(opam list -s)
    }
  '';
}
