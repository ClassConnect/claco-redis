class ApplicationController < ActionController::Base
 protect_from_forgery
after_filter :set_access

def set_access
  @response.headers["Access-Control-Allow-Origin"] = "*"
end
end
