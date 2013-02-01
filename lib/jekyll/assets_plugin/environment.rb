# 3rd-party
require 'sprockets'


# internal
require 'jekyll/assets_plugin/asset_file'
require 'jekyll/assets_plugin/liquid_processor'


module Jekyll
  module AssetsPlugin
    class Environment < Sprockets::Environment
      autoload :ContextPatch, "jekyll/assets_plugin/environment/context_patch"


      attr_reader :site


      def initialize site
        super site.source

        @site = site

        # append asset paths
        @site.assets_config.sources.each { |p| append_path p }

        self.js_compressor   = @site.assets_config.js_compressor
        self.css_compressor  = @site.assets_config.css_compressor

        register_preprocessor "text/css",               LiquidProcessor
        register_preprocessor "application/javascript", LiquidProcessor

        # bind jekyll and Sprockets context together
        context_class.instance_variable_set :@site, @site

        context_class.send :include, ContextPatch
      end


      def find_asset path, *args
        super or raise AssetFile::NotFound, "couldn't find file '#{path}'"
      end


      def index
        super.tap do |index|
          index.instance_eval do
            def find_asset path, options = {}
              site    = @environment.site
              asset   = super
              bundle  = options[:bundle]

              if asset and bundle and not site.static_files.include? asset
                site.static_files << AssetFile.new(site, asset)
              end

              asset
            end
          end
        end
      end

    end
  end
end