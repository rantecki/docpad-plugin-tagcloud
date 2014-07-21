# TagCloud Plugin for DocPad
Extends [DocPad's](https://docpad.org) tagging features by adding tag cloud generation

## Install

```
npm install --save docpad-plugin-tagcloud
```

## Usage

This plugin supercedes the now deprecated [Tagging plugin](https://github.com/rantecki/docpad-plugin-tagging/) for Docpad >= 6.46.  It works in conjunction with the new [Tags plugin](https://github.com/docpad/docpad-plugin-tags/).

Generate tag index pages for your documents as described in the [Tags plugin](https://github.com/docpad/docpad-plugin-tags/).

The plugin adds the `@getTagCloud()` template helper, which returns an object containing the tag cloud data of the form:

```
yellow:
	tag: "yellow"			// the tag name
	url: "/tags/yellow"		// URL of the tag index page
	count: 5					// number of documents containing the tag
	weight: 0.25				// weight of the tag
blue:
	tag: "blue"
	url: "/tags/blue"
	count: 3
	weight: 0.12
...
```

The following example iterates through the tag cloud and generates links to the tag index pages (in *eco*):

```
<% for tag, data of @getTagCloud(): %>
    <a href="<%= data.url %>" data-tag-count="<%= data.count %>" data-tag-weight="<%= data.weight %>">
        <%= tag %>
    </a>
<% end %>
```

Note that in this example we've added the count and weight here as HTML5 data fields so that a client-side script can apply the desired styling.  You can of course do whatever you wish with the count or weight values, such as adding inline CSS for setting the font-size (but of course we don't do that kind of thing anymore right?)

## Options

- *collectionName* : The collection containing your tag index pages.  This should probably be the same as specified for the tags plugin.
- *getTagWeight* : Override the function used to generate the tag weights (see below).
- *logLevel*: Override the log level for log messages from this plugin.  Defaults to 'info'.

### Customising the weight function

By default, the tag weights are calculated using a simple logarithmic algorithm.  If that isn't floating your proverbial boat you are free to override this function with the weight function of your choosing.  For example in your docpad config you could add:

```
plugins:
    tagcloud:
        getTagWeight: (count, maxCount) ->
            return count/maxCount
```

Here `count` is the number of occurences of the tag, and `maxCount` is the count of the tag with the highest number of occurrences.

## History
You can discover the history inside the `History.md` file

## License
Licensed under the incredibly [permissive](http://en.wikipedia.org/wiki/Permissive_free_software_licence) [MIT License](http://creativecommons.org/licenses/MIT/)
<br/>Copyright &copy; 2013 [Richard Antecki](http://richard.antecki.id.au)
