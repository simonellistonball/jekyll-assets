module Jekyll
  module AssetsPlugin
    class Renderer

      STYLESHEET = '<link rel="stylesheet" href="%s">'
      JAVASCRIPT = '<script src="%s"></script>'


      def initialize context, logical_path
        @site = context.registers[:site]
        @path = logical_path.strip
      end


      def render_asset
        @site.assets[@path].to_s
      end


      def render_asset_path
        @site.asset_path @path
      end


      def render_javascript
        @path << ".js" if File.extname(@path) != 'js'
        render_tag JAVASCRIPT
      end


      def render_stylesheet
        @path << ".css" if File.extname(@path) != 'css'
        render_tag STYLESHEET
      end


      protected


      def render_tag template
        asset = @site.assets[@path]
        (@site.assets_config.debug ? asset.to_a : [asset]).map{ |a|
          template % AssetPath.new(a).to_s
        }.join("\n")
      end

    end
  end
end

