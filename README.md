# exarepo_tasks

Some post-processing workarounds for minicomp/wax, styled off Peter Binkley's [postwax](https://github.com/pbinkley/postwax).

Here are a couple of rake tasks that can be included in a [Wax](https://github.com/minicomp/wax) project. They may eventually be packaged as a gem or incorporated into Wax itself, or be shown to be unnecessary (e.g. if they can be addressed through configuration options within Wax or within clients).

## Installation and use

Note: these instructions will be updated as development progresses.

- copy ```postwax.rake``` into ```lib/tasks``` in a Wax project
- add this line to Wax's ```Rakefile```:

```
Dir.glob("lib/tasks/*.rake").each { |r| load r }
```

While this is under development, you'll need to add ```gem 'byebug'``` to Wax's ```Gemfile```
and run ```bundle install```.

Now when you run bundle exec rake --tasks, you should see:

```
rake postwax:level0_workarounds  # Generate 90-width thumbnails, as request...
rake postwax:merge_manifests     # Merge image-level manifests to create it...
rake wax:derivatives:iiif        # generate iiif derivatives from local ima...
rake wax:derivatives:simple      # generate iiif derivatives from local ima...
rake wax:pages                   # generate collection md pages from yaml o...
rake wax:search                  # build lunr search index (with default UI...
rake wax:test                    # run htmlproofer, rspec if .rspec file ex...
```

After running ```wax:derivatives:iiif```, run ```postwax:level0_workarounds``` and ```postwax:merge_manifests```.

To see the result, start Wax locally with ```bundle exec jekyll s```, and then view the manifest
```http://127.0.0.1:4000/CKB-binder-7/img/derivatives/iiif/bigitem.json``` in the demo pages for 
[Universal Viewer](https://universalviewer.io/) or [Mirador](https://projectmirador.org/demo/).
If you do that before running ```postwax:level0_workarounds```, you'll see the problems which the
workarounds are supposed to address.


## Demo of problems
