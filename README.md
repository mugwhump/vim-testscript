# vim-testscript
vim plugin for working with testscript (.ts) files, run with QAPlayer

Features:
* Syntax highlighting for .ts automation scripts
* Built in TFS version control shortcuts (checkout, checkin, add, update)
* double-click to open documentation for the current QAPlayer statement, or open the Spira page for the current test case
* Shortcut to switch between the current .ts script and its corresponding .csv file
  * Display value of .csv variables in a tooltip when you hover over them
* Jump to variable declaration (searches project hierarchy)
* Jump to called script
* Search for scripts that call the current script
* auto-expand '//' in testscript files into %DOUBLESLASH%
* Features for working with QAPlayer output logs:
  * Syntax highlighting
  * automatically update & scroll output file as tests are run
  * double-click referenced files to open them
  * parse massive logfiles into a summary of just the errors
* Fully documented
* Can access functionality either through shortcuts or through menu items in gvim GUI

Also contains an example gvimrc file that explains how to configure the plugin, and how to set up vim nicely in general.
