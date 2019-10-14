# digests

Digests and cache static files

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     digests:
       github: Hentioe/digests.cr
     # Also need sam as a task execution tool
     sam:
       github: imdrasil/sam.cr
   ```

2. Run `shards install`

3. Create `sam.cr`

   ```crystal
   require "sam"
   load_dependencies "digests"

   # your custom tasks here

   Sam.help
   ```

## Usage

Original file tree:

    ```
    static/
    ├── css
    │   ├── app.css
    │   └── pages
    │       └── index.css
    ├── js
    │   └── app.js
    └── logo.svg
    ```

Make digests:

```bash
crystal sam.cr -- digests:make examples/static
```

Contains digests and manifest file tree:

```
static/
├── cache_manifest.json # Digests information recorded
├── css
│   ├── app-43c1d0618c68fde58d940f3375d919c8.css
│   ├── app.css
│   └── pages
│       ├── index.css
│       └── index-d41d8cd98f00b204e9800998ecf8427e.css
├── js
│   ├── app-42a314210f311e84f2dc144cbddeaac9.js
│   └── app.js
├── logo-9769baab21626e47c5601f5ec037c7bf.svg
└── logo.svg
```

The `cache_manifest.json` content:

```json
{
  "digests": {
    "/js/app-42a314210f311e84f2dc144cbddeaac9.js": {
      "logical_path": "/js/app.js",
      "mtime": 1570969634,
      "size": 91,
      "digest": "42a314210f311e84f2dc144cbddeaac9"
    },
    "/css/app-43c1d0618c68fde58d940f3375d919c8.css": {
      "logical_path": "/css/app.css",
      "mtime": 1571028643,
      "size": 100,
      "digest": "43c1d0618c68fde58d940f3375d919c8"
    },
    "/css/pages/index-d41d8cd98f00b204e9800998ecf8427e.css": {
      "logical_path": "/css/pages/index.css",
      "mtime": 1571015787,
      "size": 0,
      "digest": "d41d8cd98f00b204e9800998ecf8427e"
    },
    "/logo-9769baab21626e47c5601f5ec037c7bf.svg": {
      "logical_path": "/logo.svg",
      "mtime": 1571014151,
      "size": 859,
      "digest": "9769baab21626e47c5601f5ec037c7bf"
    }
  },
  "latest": {
    "/js/app.js": "/js/app-42a314210f311e84f2dc144cbddeaac9.js",
    "/css/app.css": "/css/app-43c1d0618c68fde58d940f3375d919c8.css",
    "/css/pages/index.css": "/css/pages/index-d41d8cd98f00b204e9800998ecf8427e.css",
    "/logo.svg": "/logo-9769baab21626e47c5601f5ec037c7bf.svg"
  },
  "version": 1
}
```

## Development

```crystal
Digests.init "examples/static" # Default "static"
Digests.logical_path("/js/app.js") # => /js/app-42a314210f311e84f2dc144cbddeaac9.js
```

It is generally used in backend templates, for example:

```html
<script defer src="<%= Digests.logical_path("/js/app.js") %>"></script>
```

## Contributing

1. Fork it (<https://github.com/Hentioe/digests.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Hentioe](https://github.com/Hentioe) - creator and maintainer
