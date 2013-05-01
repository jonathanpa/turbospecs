Turbospecs
==========

## What is ?

Take vim, tmux, rspec (rspec-console -facultative-) and **Turbospecs**.
Mix all together and you get one of the best integrated environment to run rspec using vim.

More seriously, **Turbospecs** is a vim plugin to integrate your rspec workflow into your vim and tmux sessions.

## Requirements

To use **Turbospecs**, you need :
* Vim installed with ruby support. You can check it by typing in your terminal : `vim --version | grep +ruby`.
* tmux.
* [Vimux](https://github.com/benmills/vimux).

## Installation

With [Pathogen](https://github.com/tpope/vim-pathogen) : move the entire folder extracted from the tarball into `~/vim/bundle`.

## How to use ?

Open a tmux pane with vimux and then :
* In a `spec` file, run rspec for the file specs with the command `:TurboSpec`.
* In a `spec` file, run rspec for the line under the cursor with the command `:TurboSpecLine`.
* Rerun the latest rspec command with the command `:TurboSpecAgain`.
* *If you are using [rspec-console](https://github.com/nviennot/rspec-console)*, you can *reload* a file with `:TurboSpecLoad`.

### The automode

The **automode** is done to be used with [rspec-console](https://github.com/nviennot/rspec-console) to *autoload* your files (models, controllers, ...) and *autorun* the spec files when they are saved.

Enable/disable the **automode** with the command `:TurboSpecAutoMode`.
