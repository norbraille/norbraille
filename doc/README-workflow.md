# Workflow converting from Word to html

## Introduction

This document describes the workflow for how we in the Norwegian Braille Authority make our braille standards published online.

## Background

In the Norwegian Braille Authority we have for years written our standards in Microsoft Word. From the Word document we've converted to pdf for publishing on our web page and for black printing on paper. For 6 dot braille on paper, we've used an old program package called CX for Word, which are still used in the nordic countries. The home page is at
[CX for Word](http://54eb242ea2e18-mjukaverktyg.se.sitebuilder.loopia.com/).

Obviously our standards are full of examples with braille output. To get appealing visually braille in the Word document and pdf, we've used an old font called BLOCK. This font is based on Eurobraille, which means that letters like a-z have common braille symbols, numbers 1-9 is represented by adding dot 6 to the letter a-i and so on. Reading this output on a braille display with a different braille table get odd result.

About five years ago the Braille Authority started a project to find an
appropriate way to publish our standards online. We had two goals for this project:

1. ensure good readability both visually and on a braille display

2. use html as file format.

Although there are a couple of fonts out there that display braille, we didn't manage to find any that have definitions for the Unicode braille block and at the same time have shadow for unraised dots. As part of this project, therefor, we have developed a set of new fonts.

### About the fonts

We hired a programmer, Jan Martin Kvile, to create all the necessary fonts. We have fonts with and without shadows of unraised dots as well as 6- and 8-dot. They are free to use and are available from within the fonts directory in this repository.

## The workflow

If you want to reproduce the workflow, you'll need the Pandoc utility from [https://pandoc.org](pandoc.org). Additionally you'll need two Perl scripts that we have developed for this task. They are both found in the utils/scripts folder in this repo. You'll also need a template for Pandoc, found in the utils/pandoc_template folder. place it in your HOME directory under .local/share/pandoc/templates folder. Create it if necessary.

To view the result, you'll need to place the resulting html file on a web server. Put the appropriate fonts in the same directory, e.g. by extracting the file NorBraille_woff.zip from within the fonts directory.

### Step by step processing

1. Convert the Word document to OpenDocument format (odt), for example: ``openoffice.org --convert-to odt <filename>.docx``
2. Go to an empty directory and Extract the odt file wiht the unzip: ``unzip <path_to_file>.odt``
3. Convert the text set with the BLOCK font by running the script odt_contentxml_unicodebrl.pl like this: ``odt_contentxml_unicodebrl.pl content.xml >tmp.xml``
4. Move the temp file to content.xml
5. Creat the odt file with zip: ``zip -rp <path_to_filename>.odt *``
6. Convert the odt file to docx: ``openoffice.org --convert-to docx <file>.odt``
7. Convert to html with Pandoc, someting like: ``pandoc -s --toc -V lang=no --template=pandoc-modified-template.html --metadata title="Document title" <file>.docx -o <file>.html``
8. The table of content section is at the very beginning of the html file. Move it manually to where you want to have it.
9. Place the characters from the Unicode braille block in span elements with the class set to unicodebrl with the html_set_class4unicodebrl.pl script, e.g.: ``html_set_class4unicodebrl.pl <file>.html >>another_file>.html``

### Some notes

We convert the Word document to odt because the xml code in an odt file is much simpler to work with than the xml code in a docx file.

We convert the odt back to a Word document in step 6. This is because there is a bug hitting us in Pandoc when converting from odt to html.

