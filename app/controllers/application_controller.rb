class ApplicationController < ActionController::API
  include Authenticatable
  include JsonResponseHelper
end
