class User

	def username
		@username
	end

	def initialize(username, password)
		@username = username
		@password = password
	end

	def ==(another_user)
		username == another_user.username
	end
end