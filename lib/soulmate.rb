require 'uri'
require 'multi_json'
require 'redis'

require 'soulmate/version'
require 'soulmate/helpers'
require 'soulmate/base'
require 'soulmate/matcher'
require 'soulmate/loader'

module Soulmate

  extend self

  MIN_COMPLETE = 2
  DEFAULT_STOP_WORDS = ["vs", "at", "the"]

  def redis=(url)
    @redis = nil
    @redis_url = url
    redis
  end

  def redis
    @redis ||= (
      #url = URI(@redis_url || ENV["REDIS_URL"] || "redis://127.0.0.1:6379/0")
	url = URI(@redis_url || ENV["REDIS_URL"] || "redis://redistogo:622aa4bb5b4d526ce343a8f8a88c908c@scat.redistogo.com:9545/")

      ::Redis.new({
        :host => url.host,
        :port => url.port,
        :db => url.path[1..-1],
        :password => url.password
      })
    )
  end

  def stop_words
    @stop_words ||= DEFAULT_STOP_WORDS
  end

  def stop_words=(arr)
    @stop_words = Array(arr).flatten
  end

end
