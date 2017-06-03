# 130-web

Public course materials for [UCSD CSE 130](https://ucsd-cse130.github.io/web)

## Install

You too, can build this webpage locally, like so:

```bash
$ git clone https://github.com/ucsd-progsys/131-web.git
$ cd 131-web
$ make
```

To then update the webpage after editing stuff, do:

```bash
$ make upload
```

The website will live in `_site/`.

## Customize

By editing the parameters in `siteCtx` in `Site.hs`

## View

You can view it by running

```bash
make server
```

## Update

Either do

```bash
make upload
```

or, if you prefer

```bash
make
cp -r _site/* docs/
git commit -a -m "update webpage"
git push origin master
```

## Credits

This theme is a fork of [CleanMagicMedium-Jekyll](https://github.com/SpaceG/CleanMagicMedium-Jekyll)
originally published by Lucas Gatsas.
