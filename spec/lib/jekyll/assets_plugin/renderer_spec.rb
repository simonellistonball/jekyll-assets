# stdlib
require "ostruct"


require "spec_helper"


module Jekyll::AssetsPlugin
  describe Renderer do

    let(:site) do
      Jekyll::Site.new Jekyll.configuration({
        "source"      => fixtures_path.to_s,
        "destination" => @dest.to_s,
        "assets"      => assets_config
      })
    end


    let(:renderer) do
      context = OpenStruct.new(:registers => { :site => site })
      Renderer.new context, "app"
    end


    describe "#render_javascript" do
      subject { renderer.render_javascript }

      context "when debug mode enabled" do
        let(:assets_config){ Hash[:debug, true] }
        it { should match %r{^(\s*<script src="[^"]+"></script>\s*){3}$} }
      end

      context "when debug mode disabled" do
        let(:assets_config){ Hash[:debug, false] }
        it { should match %r{^(\s*<script src="[^"]+"></script>\s*){1}$} }
      end
    end


    describe "#render_stylesheet" do
      subject { renderer.render_stylesheet }

      context "when debug mode enabled" do
        let(:assets_config){ Hash[:debug, true] }
        it { should match %r{^(\s*<link rel="stylesheet" href="[^"]+">\s*){3}$} }
      end

      context "when debug mode disabled" do
        let(:assets_config){ Hash[:debug, false] }
        it { should match %r{^(\s*<link rel="stylesheet" href="[^"]+">\s*){1}$} }
      end
    end

  end
end
