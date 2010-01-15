require 'spec/rake/spectask'

module FoodHelpers
  class FoodSpecTask < Spec::Rake::SpecTask
    def initialize(spec_root, name=:spec)
      @spec_root = spec_root
      super(name)
      spec_opts << "--require #{@spec_root}/spec/spec_helper" if File.exists?("#{@spec_root}/spec/spec_helper.rb")
      spec_opts << "--format specdoc"
      spec_opts << "--color"
    end

    def spec_files=(fnames)
      if fnames.is_a? String
        fnames = [fnames]
      end
      fnames.map! {|fname| "#{@spec_root}/#{fname}" }
      super(fnames)
    end
  end
end
