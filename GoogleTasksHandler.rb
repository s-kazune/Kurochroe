# encoding: utf-8

require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require 'google/api_client/auth/file_storage'
require 'pp'
require 'kconv'
require 'JSON'


class GoogleTasksHandler
	# 初期化処理．
	########################################################################
	def initialize(name)
		@name = name
		@tasklist_id = ""
		@client = Google::APIClient.new(
			:application_name => 'Kurochroe',
			:application_version => '0.1.0'
		)
		@auth_file = Google::APIClient::FileStorage.new("./auth/google_credentials.json")
		
		auth_process
		
		@gtasks = @client.discovered_api('tasks')
		@tasklist_id = fetch_tasklist_id

		puts "GTasks > GTasksHandler READY!"
	end

	def add(body,month=nil,day=nil)
		puts "GTasks > -- addtask --"

		if month then
			t = Time.new
			due ="#{t.year}-#{month}-#{day}T00:00:00.000Z"
			insert_task(body,due)
		else
			insert_task(body)
		end
	end

	def insert_task body,due=nil
		if due.nil? then
			@client.execute(
				:api_method => @gtasks.tasks.insert,
				:parameters => {"tasklist" => @tasklist_id},
				:body_object => {"title" => body}
			)
		else
			@client.execute(
				:api_method => @gtasks.tasks.insert,
				:parameters => {"tasklist" => @tasklist_id},
				:body_object => {"title" => body, "due" => due}
			)
		end
	end

	# methods below are generally called once in the initialize section.
	def auth_process
		if @auth_file.authorization.nil?
   			make_auth
		else
			@client.authorization = @auth_file.authorization
		end
	end

	def make_auth
   			client_secrets = Google::APIClient::ClientSecrets.load("./auth/google_secrets.json")
   			
			flow = Google::APIClient::InstalledAppFlow.new(
				:client_id     => client_secrets.client_id,
				:client_secret => client_secrets.client_secret,
				:scope         => ['https://www.googleapis.com/auth/tasks']
			)

   			@client.authorization = flow.authorize
   			@auth_file.write_credentials(@client.authorization.dup)
	end

	def fetch_tasklist_id
		raw_tasklists = @client.execute(:api_method => @gtasks.tasklists.list).body.tosjis
		parsed_tasklists = JSON.parse(raw_tasklists)["items"]
		
		parsed_tasklists.each do |tasklist|
			if tasklist["title"] == @name then
				return tasklist["id"]
			end
		end
	end

end