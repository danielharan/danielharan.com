module Rack
  class DefaultIndex
    def initialize(app, options={})
      @app = app
    end
    
    def call(env)
      path = env['PATH_INFO'].chomp('/')
      env['PATH_INFO'] = 'index.html' if ['', 'index', 'index.htm'].include?(path)
      @app.call(env)
    end
  end
  
  class NukeWWW
    def initialize(app, options={})
      @app = app
    end
    
    def call(env)
      return redirect(env['HTTP_HOST'].gsub('www\.', '')) if env['HTTP_HOST'] =~ /^www/
      @app.call(env)
    end
  end
end

use Rack::NukeWWW
use Rack::DefaultIndex
use Rack::Static, :urls => [""], :root => "public"

run proc { |env| [404, {"Content-Type"=>"text/html"}, ["Not found..."]] }