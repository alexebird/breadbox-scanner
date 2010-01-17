require 'spec/rake/spectask'

module FoodHelpers
  class FoodSpecTask < Spec::Rake::SpecTask
    def initialize(spec_root, name=:spec)
      @spec_root = spec_root
      super(name)
      self.ruby_cmd = "cd #@spec_root ; #{RUBY}"
      self.spec_opts << "--require #{@spec_root}/spec/spec_helper" if File.exists?("#{@spec_root}/spec/spec_helper.rb")
      self.spec_opts << "--format specdoc"
      self.spec_opts << "--color"
      self.spec_opts << " ; cd -"
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
