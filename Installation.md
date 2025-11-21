Installation requirements
=========================

The following system packages need to be installed to use all the features of this module.

The FontConfig library
----------------------

On Debian:

    $ sudo apt-get install -y libfontconfig1-dev
    $ sudo apt-get install -y fontconfig 
    $ sudo apt-get install -y locate 
    $ sudo apt-get install -y libharfbuzz-dev
    $ sudo apt-get install -y fonts-freefont-otf

On MacOS:

    $ brew install fontconfig
    $ brew install freetype
    $ brew install harfbuzz
    $ brew install --cask font-freefont

On Windows:

    $ choco install fontconfig # if available

Other systems
=============

If this package does not install the fonts for your system you can obtain them from the following sources:

On systems derived from Debian:

    $ sudo aptitude install fonts-freefont-otf

On MacOS:

    $ brew install --cask font-freefont

On Windows:

    $ choco install font-freefont
    $ choco install font-dejavu

On other systems the files may be downloaded from [https://ftp.gnu.org/gnu/freefont](https://ftp.gnu.org/gnu/freefont) and installed in the following locations for the following systems:

On Linux:

    /usr

On MacOS:

    /usr

On Windows:

    /usr

