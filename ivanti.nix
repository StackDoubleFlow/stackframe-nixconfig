{
  pkgs,
  lib,
  ...
}: let
  pulse-cookie = pkgs.python3.pkgs.buildPythonApplication rec {
    pname = "pulse-cookie";
    version = "1.0";

    src = pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-ZURSXfChq2k8ktKO6nc6AuVaAMS3eOcFkiKahpq4ebU=";
    };

    propagatedBuildInputs = [
      pkgs.python3.pkgs.pyqt6
      pkgs.python3.pkgs.pyqt6-webengine
      pkgs.python3.pkgs.setuptools
      pkgs.python3.pkgs.setuptools-scm
    ];

    preBuild = ''
      cat > setup.py << EOF
      from setuptools import setup

      # with open('requirements.txt') as f:
      #     install_requires = f.read().splitlines()

      setup(
        name='pulse-cookie',
        packages=['pulse_cookie'],
        package_dir={"": 'src'},
        version='1.0',
        author='Raj Magesh Gauthaman',
        description='wrapper around openconnect allowing user to log in through a webkit window for mfa',
        install_requires=[
          'PyQt6-WebEngine',
        ],
        entry_points={
          'console_scripts': ['get-pulse-cookie=pulse_cookie._cli:main']
        },
      )
      EOF
    '';

    meta = with lib; {
      homepage = "https://pypi.org/project/pulse-cookie/";
      description = "wrapper around openconnect allowing user to log in through a webkit window for mfa";
      license = licenses.gpl3;
    };

    pyproject = true;
    build-system = [ pkgs.python3.pkgs.setuptools ];
  };
  start-pulse-vpn = pkgs.writeShellScriptBin "start-pulse-vpn" ''
    HOST=https://vpn.coeit.osu.edu
    DSID=$(${pulse-cookie}/bin/get-pulse-cookie -n DSID $HOST)
    sudo ${pkgs.openconnect}/bin/openconnect --protocol nc -C DSID=$DSID $HOST
  '';
in {
  environment.systemPackages = with pkgs; [
    openconnect
    start-pulse-vpn
    qt6.qtwebengine
    qt6.qtwayland
  ];
}