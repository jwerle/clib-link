clib-link
=========

Symlink an existing clib project source to yours

## install

With [clib](https://github.com/clibs/clib):

```sh
$ clib install jwerle/clib-link
```

From source:

```sh
$ git clone git@github.com:jwerle/clib-link.git /tmp/clib-link
$ cd /tmp/clib-link
$ make install
```

## usage

Making a clib project global:

```sh
$ cd /path/to/clib/project
$ clib link
```

This will symlink your source defined in `package.json` to
`/usr/local/clibs/{PROJECT_NAME}`. Use `{PROJECT_NAME}` as the
clib name when linking back to your project.

Linking a global project to yours:

```sh
$ clib link my-lib-project
```

The project `my-lib-project` will be symlinked to your `deps/` directory.

## license

MIT
