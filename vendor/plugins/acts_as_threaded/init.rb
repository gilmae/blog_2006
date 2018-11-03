require 'acts_as_threaded'
ActiveRecord::Base.send(:include, ActiveRecord::Acts::Threaded)

require File.dirname(__FILE__) + '/lib/thread_branch'
