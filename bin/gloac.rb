require 'thor'

class GloacCli < Thor

  package_name "gloac"

  desc 'init', 'Create and initialise new gloac configuration location'
  method_option :directory, :type => :string, :required => true, :default => nil, :aliases => '-d',
      :desc => 'Version to compile by which subcomponents are referenced'
  method_option :defaults, :type => :boolean, :default => false,
      :desc => 'Use default recommended configuration'

  def init()


  end

  desc 'deploy', 'Deploy Gloac to AWS cloud using given configuration'
  method_option :directory, :type => :string, :required => true, :default => nil, :aliases => '-d',
      :desc => 'Version to compile by which subcomponents are referenced'

  def deploy()

  end
end


GloacCli.start
