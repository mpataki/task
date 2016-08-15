require 'uri'
require 'net/http'
require 'json'
require './lib/gist.rb'
require 'byebug' # DELETE ME

def report_gist_description(user, time = Time.now)
  "#{user}_report_#{time.strftime('%Y-%m-%d')}"
end

# return nil if none exist
def find_report_gist_from_today(user, gists)
  description = report_gist_description(user)
  gists.find { |gist| gist['description'] == description }
end

def create_report_gist(user, api_token, time = Time.now)
  puts 'Creating a new report'
  description = report_gist_description(user, time)
  file_name = "#{description}.md"

  params = {
    public: false,
    description: description,
    files: {
      file_name => {
        content: "test" # this is where the messages would go ;)
      }
    }
  }

  Gist.create(user, api_token, params)
end

user = 'mpataki' # probably want to pull this from a config
api_token = File.read('gist_token').strip

gists = Gist.get_recent_gists_for_user(user, api_token)
report_gist = find_report_gist_from_today(user, gists)
report_gist = create_report_gist(user, api_token) if report_gist.nil?
puts report_gist
