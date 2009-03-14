# load rubygems and wirble
require 'rubygems' rescue nil
require 'pp'
require 'wirble'

# load wirble
Wirble.init
Wirble.colorize

IRB.conf[:AUTO_INDENT] = true

## method tracing

# enable tracing
def enable_trace( event_regex = /^(call|return)/, class_regex = /IRB|Wirble|RubyLex|RubyToken/ )
  puts "Enabling method tracing with event regex #{event_regex.inspect} and class exclusion regex #{class_regex.inspect}"

  set_trace_func Proc.new{|event, file, line, id, binding, classname|
    printf "[%8s] %30s %30s (%s:%-2d)\n", event, id, classname, file, line if
      event          =~ event_regex and
      classname.to_s !~ class_regex
  }
  return
end

# disable tracing
def disable_trace
  puts "Disabling method tracing"

  set_trace_func nil
end

access helper methods from the rails console
http://errtheblog.com/post/43
def Object.method_added(method)
  return super(method) unless method == :helper
  (class<<self;self;end).send(:remove_method, :method_added)

  def helper(*helper_names)
    returning $helper_proxy ||= Object.new do |helper|
      helper_names.each { |h| helper.extend "#{h}_helper".classify.constantize }
    end
  end

  helper.instance_variable_set("@controller", ActionController::Integration::Session.new)

  def helper.method_missing(method, *args, &block)
    @controller.send(method, *args, &block) if @controller && method.to_s =~ /_path$|_url$/
  end

  helper :application rescue nil
end if ENV['RAILS_ENV']


# watching AR do it's thing
# http://weblog.jamisbuck.org/2007/1/31/more-on-watching-activerecord
# + comment from the UnderPantsGnome
def log_to(stream, colorize=true)
  ActiveRecord::Base.logger = Logger.new(stream)
  ActiveRecord::Base.clear_active_connections!
  ActiveRecord::Base.colorize_logging = colorize
end

# annotate column names of an AR model
def show(obj)
  y(obj.send("column_names"))
end

class Object
  def local_methods
    m = methods - Object.new.methods
    m.sort
  end
end