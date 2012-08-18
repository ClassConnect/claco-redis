require 'sinatra/base'
require 'soulmate'
require 'rack/contrib'

module Soulmate

  class Server < Sinatra::Base
    include Helpers

    use Rack::JSONP

    def handle_jsonp(data)
      if params[:callback]
        content_type 'text/javascript', :charset => 'utf-8'
        "#{params[:callback]}(#{data})"
      else
        content_type 'application/json', :charset => 'utf-8'
        data
      end
    end

    get '/' do
      MultiJson.encode({ :soulmate => Soulmate::Version::STRING, :status   => "ok" })
    end

    get '/search' do
      raise Sinatra::NotFound unless (params[:term] and params[:types] and params[:types].is_a?(Array))

      limit = (params[:limit] || 6).to_i
      types = params[:types].map { |t| normalize(t) }
      term  = params[:term]

      results = {}
      smushset = []
      retstr = '['

      types.each do |type|
        matcher = Matcher.new(type)
	#matcher.matches_for_term(term, :limit => limit).each { |result| smushset << "{ label: \"#{ result['data']['label'] }\", value: \"#{ result['data']['value'] }\" }" }
	matcher.matches_for_term(term, :limit => limit).each { |result| smushset << { :title => result['data']['label'], :label => result['data']['value'] } }
      end

      #smushset.uniq.each { |result| retstr += "#{result}," }

      #smushset.any? ? retstr[-1] = ']' : retstr = ''

      #return retstr

      return handle_jsonp(ultiJson.encode(smushset.uniq))

    end

    not_found do
      content_type 'application/json', :charset => 'utf-8'
      handle_jsonp MultiJson.encode({ :error => "not found" })
    end

  end
end
