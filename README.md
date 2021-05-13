# vim-pconf

Project-local vimrc files

## Installation

Standard plugin installation. I use minpac

## Usage

Create a `.vimrc.local` file in a project directory. The first time you open
`vim` in the directory, `vim` will ask if you want to register the file. If you
do, the file will be hashed and the hash placed in a registry file. Next time
you open `vim` in that directory, `vim` will see that the file has been
registered and automatically check the hash.

If the hash is identical, the file will be sourced automatically. If the hashes
differ, a warning will be printed and the file will **not** be sourced.

A `.vimrc.local` file in the current directory can be manually registered by
using

```vim
:RegisterPconf
```

This is also the command used to re-register a file by updating the stored hash
after making changes.

## Configuration

You can use a different file name than `.vimrc.local` by setting

```vim
let g:pconf = '<pconf filename>'
```

The hash database is stored in the same directory as the plugin by default, but
that can be changed by setting

```vim
let g:pconf_db = '<pconf db filename>'
```

This must be set to an absolute path.
