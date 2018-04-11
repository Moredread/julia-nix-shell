# found it somewhere on the internet, attribution with license will follow
with import <nixpkgs> {};
{
    repositoryName = stdenv.mkDerivation {
    name = "repositoryName";
    buildInputs = [
      julia_05 # works with julia (v0.4) too
      # Any other dependency you need
      python
      pythonPackages.jupyter
      gnum4
      zeromq
      cmake
    ];

    src = ./.;

    SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt";
    GIT_SSL_CAINFO="/etc/ssl/certs/ca-certificates.crt";

    # First important part: Add here the dependencies the packages you want to install need
    LD_LIBRARY_PATH="${glfw}/lib:${mesa}/lib:${freetype}/lib:${imagemagick}/lib:${portaudio}/lib:${libsndfile.out}/lib:${libxml2.out}/lib:${expat.out}/lib:${cairo.out}/lib:${pango.out}/lib:${gettext.out}/lib:${glib.out}/lib:${gtk3.out}/lib:${gdk_pixbuf.out}/lib:${cairo.out}:${tk.out}/lib:${tcl.out}/lib:${pkgs.sqlite.out}/lib:${pkgs.zlib}/lib:${mbedtls.out}/lib";
    shellHook = ''
      unset http_proxy
      # This is the second important part. Set a relative julia_pkgdir path so that they are specific to this
      # Nix env environment and are not global
      export JULIA_PKGDIR=$(realpath ./.julia_pkgs)
      if [ ! -d $JULIA_PKGDIR ]; then
        echo "Initialize Julia package directory"
        julia -e "Pkg.init()"
        mkdir -p $JULIA_PKGDIR
      else
        echo "Update Julia packages"
        julia -e "Pkg.update()"
      fi
      julia -e 'Pkg.add("IJulia")'
      julia -e 'Pkg.add("SugarBLAS")'
      julia -e 'Pkg.add("Plots")'
      julia -e 'Pkg.add("PyPlot")'
      julia -e 'Pkg.add("Gadfly")'
      '';
    };
}
