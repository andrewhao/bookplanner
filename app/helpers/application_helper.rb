module ApplicationHelper
  def sandboxed?
    ENV['APP_ENV'] == 'sandbox'
  end
end
