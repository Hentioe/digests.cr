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

```
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

``` bash
crystal sam.cr -- digest:make
```

Contains digests and manifest file tree:

```
static/
├── cache_manifest.json # <- Digests information recorded
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

## Development

```crystal
Digests.init
Digests.logical_path("/js/app.js") # => /js/app-42a314210f311e84f2dc144cbddeaac9.js
```

It is generally used in backend templates, for example:

```html
<script defer src="<%= Digests.logical_path("/js/app.js") %>"></script>
```

## Contributing

1. Fork it (<https://github.com/Hentioe/digests/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Hentioe](https://github.com/Hentioe) - creator and maintainer
