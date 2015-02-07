module.exports = (BasePlugin) ->

	class TagCloud extends BasePlugin
		name: 'tagcloud'

		config:
			collectionName: 'tags'
			logLevel: 'info'
			getTaggedFiles: (docpad, tag) ->
				return docpad.getFiles({tags: $has: tag})

			getTagWeight: (count, maxCount) ->
				# apply logarithmic weight algorithm
				logmin = 0
				logmax = Math.log(maxCount)
				result = (Math.log(count) - logmin) / (logmax - logmin)
				return result

		tagCloud: {}
		maxCount: 0

		extendTemplateData: ({templateData}) ->
			me = @
			templateData.getTagCloud = ->
				return me.tagCloud
			@

		renderBefore: ({collection, templateData}, next) ->
			config = @getConfig()
			docpad = @docpad
			plugin = @

			@tagCloud = {}	# reset every time renderBefore is triggered
			@maxCount = 0

			tagDocs = docpad.getCollection(config.collectionName)
			tagDocs?.forEach (doc) =>
				tag = doc?.get('tag')
				taggedfiles = config.getTaggedFiles.call(plugin, docpad, tag)
				count = taggedfiles?.length or 0

				@tagCloud[tag] ?=
					tag: tag,
					count: count,
					url: doc?.get('url') or ''
					weight: 0

				@maxCount = count if count > @maxCount

			docpad.log config.logLevel, "tagcloud: maxCount="+@maxCount

			for own tag, item of @tagCloud
				@tagCloud[tag].weight = @config.getTagWeight(item.count, @maxCount)
				docpad.log config.logLevel, "tagcloud: tag="+tag+", count="+item.count+", weight="+@tagCloud[tag].weight

			next()
			@
