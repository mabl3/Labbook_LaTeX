# Labbook
A simple collection of initial LaTeX files and Perl scripts to get started with a labbook, e.g. if you want to keep track of work you do from day to day during a thesis.

# Credits
The idea for this setup comes from Reddit user */u/riboch* in this post: https://www.reddit.com/r/LaTeX/comments/2ty6pj/setting_up_a_lab_notebook_using_latex/co3kwe1/

These files are just one possible implementation of their idea. I created it to make it easy to maintan the labbook.

# Usage
Download the files in this repository to get an "empty" labbook. Run the Perl script `_addNewDay.pl` to add a new LaTeX file for today, you can find it as `YYYY/MM/YYYYMMDD.tex` where `YYYY`, `MM` and `DD` stand for today's year, month and day, respectively. Use your favourite editor to write down today's progress. Compile `Labbook.tex`. Done.

# Details
## Predefined Files
`commandLibrary.tex`
* Put custom commands (e.g. `\newcommand{}{}`) in here

`documentSetup.tex`
* Include packages, their settings and other global document settings here

`Labbook.tex`
* Compile this file to get your labbook
* You should not need to touch this, although you sometimes may want to comment out single years to speed up compilation
* Do not touch the `[PERL INPUT TAG]`!

`Appendix/*.tex`
* These files contain quotes from */u/riboch* describing what to put in here. Of course, feel free to adjust this as you like

`Bibliograpyh/Bibliography.tex`
* Put BibLaTeX bibliography tags in here

## Guidelines
* Each new day gets a `\label{sec:YYYYMMDD}` so you can `\nameref{}` to each day in your labbook
* Put figures etc. in a subfolder for the respective day, i.e. in `YYYY/MM/DD/figure.png`
