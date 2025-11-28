[![Actions Status](https://github.com/tbrowder/GNU-FreeFont-OTF/actions/workflows/linux-otf.yml/badge.svg)](https://github.com/tbrowder/GNU-FreeFont-OTF/actions) [![Actions Status](https://github.com/tbrowder/GNU-FreeFont-OTF/actions/workflows/macos-otf.yml/badge.svg)](https://github.com/tbrowder/GNU-FreeFont-OTF/actions) [![Actions Status](https://github.com/tbrowder/GNU-FreeFont-OTF/actions/workflows/windows-otf.yml/badge.svg)](https://github.com/tbrowder/GNU-FreeFont-OTF/actions)

NAME
====

**GNU::FreeFont-OTF** - Provides a collection of GNU FreeType fonts for use in Raku PDF creation

SYNOPSIS
========

```raku
use Test;
use PDF::Content;
use GNU::FreeFont-OTF;

# Use the provided class to create individual font objects
# of the desired font face:
my $ff = GNU::FreeFont-OTF.new;

# Select the GNU FreeFont 'Free Serif' to be loaded
# as a PDF font object to be used to print text on a PDF page:
my $font  = $ff.get-font: "Free Serif";
isa-ok $font, PDF::Content::FontObj;
# OUTPUT:
ok 1 - The object is-a 'PDF::Content::FontObj'
1..1
```

DESCRIPTION
===========

**GNU::FreeFont-OTF** is a Raku package that provides easy handling of the set of GNU FreeFont OpenType fonts which descended from the classic Adobe Type 1 free fonts (shown in Table 2 below). Unlike the original Adobe fonts, these fonts also include many hundreds of Unicode characters that can be used with many languages. The fonts are also among the few, freely-available fonts that have Type 1 kerning.

See [GNU FreeFont](https://www.gnu.org/software/freefont/sources/) for much more information on the sources and Unicode coverage of the GNU FreeFonts collection.

Installation requirements
=========================

Your system may not have all the required packages to support this Raku module. See [Installation](./Installation.md) for those requirements to ensure they are installed before running `zef install GNU::FreeFont-OTF`.

Using this module
=================

The following tables show the hash codes (keys) to use to select the desired font objects. The first table uses codes derived from the GNU FreeFont font family name plus any other descriptors: weight ('Bold'), and slant ('italic' or 'oblique'). The second table shows the Adobe heritage font name from which it was derived.

Note the *Code* and *Code2* columns. Each row contains equivalent code you may use to select the desired GNU FreeFont face.

You may also use the font name in the first column or the reference number to select the font.

Font samples
------------

This package includes an installed Raku script, `make-gnu-ff-samples`, to produce a page of *pangrams* in several languages for a selected font. (See more information about pangrams and a large list of them for many languages at [https://clagnut.com](https://clagnut.com).)

Please create an issue if you want one changed or added for your language. Languages currently shown are: 

  * de - German

  * en - English

  * es - Spanish

  * fr - French

  * id - Indonesian

  * it - Italian

  * nb - Norwegian (Bokmål)

  * nl - Dutch

  * nn - Norwegian (Nyorsk)

  * pl - Polish

  * ro - Romanian

  * ru - Russian

  * uk - Ukranian 

Table 1
-------

<table class="pod-table">
<caption>The GNU FreeFont Collection</caption>
<thead><tr>
<th>GNU FreeFont</th> <th>Code</th> <th>Code2</th> <th>Reference No.</th>
</tr></thead>
<tbody>
<tr> <td>Free Serif</td> <td>se</td> <td>t</td> <td>1</td> </tr> <tr> <td>Free Serif Bold</td> <td>seb</td> <td>tb</td> <td>2</td> </tr> <tr> <td>Free Serif Italic</td> <td>sei</td> <td>ti</td> <td>3</td> </tr> <tr> <td>Free Serif Bold Italic</td> <td>sebi</td> <td>tbi</td> <td>4</td> </tr> <tr> <td>Free Sans</td> <td>sa</td> <td>h</td> <td>5</td> </tr> <tr> <td>Free Sans Bold</td> <td>sab</td> <td>hb</td> <td>6</td> </tr> <tr> <td>Free Sans Oblique</td> <td>sao</td> <td>ho</td> <td>7</td> </tr> <tr> <td>Free Sans Bold Oblique</td> <td>sabo</td> <td>hbo</td> <td>8</td> </tr> <tr> <td>Free Mono</td> <td>m</td> <td>c</td> <td>9</td> </tr> <tr> <td>Free Mono Bold</td> <td>mb</td> <td>cb</td> <td>10</td> </tr> <tr> <td>Free Mono Oblique</td> <td>mo</td> <td>co</td> <td>11</td> </tr> <tr> <td>Free Mono Bold Oblique</td> <td>mbo</td> <td>cbo</td> <td>12</td> </tr>
</tbody>
</table>

Table 2
-------

<table class="pod-table">
<caption>The Equivalent Adobe Type 1 Fonts</caption>
<thead><tr>
<th>Adobe Type 1 Name</th> <th>Code</th> <th>Code2</th> <th>Reference No.</th>
</tr></thead>
<tbody>
<tr> <td>Times</td> <td>se</td> <td>t</td> <td>1</td> </tr> <tr> <td>Times Bold</td> <td>seb</td> <td>tb</td> <td>2</td> </tr> <tr> <td>Times Italic</td> <td>sei</td> <td>ti</td> <td>3</td> </tr> <tr> <td>Times Bold Italic</td> <td>sebi</td> <td>tbi</td> <td>4</td> </tr> <tr> <td>Helvetica</td> <td>sa</td> <td>h</td> <td>5</td> </tr> <tr> <td>Helvetica Bold</td> <td>sab</td> <td>hb</td> <td>6</td> </tr> <tr> <td>Helvetica Oblique</td> <td>sao</td> <td>ho</td> <td>7</td> </tr> <tr> <td>Helvetica Bold Oblique</td> <td>sabo</td> <td>hbo</td> <td>8</td> </tr> <tr> <td>Courier</td> <td>m</td> <td>c</td> <td>9</td> </tr> <tr> <td>Courier Bold</td> <td>mb</td> <td>cb</td> <td>10</td> </tr> <tr> <td>Courier Oblique</td> <td>mo</td> <td>co</td> <td>11</td> </tr> <tr> <td>Courier Bold Oblique</td> <td>mbo</td> <td>cbo</td> <td>12</td> </tr>
</tbody>
</table>

AUTHOR
======

Tom Browder <tbrowder@acm.org>

COPYRIGHT AND LICENSE
=====================

© 2025 Tom Browder

This library is free software; you may redistribute it or modify it under the Artistic License 2.0.

