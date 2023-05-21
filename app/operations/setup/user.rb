# rubocop:disable Naming/AccessorMethodName
# rubocop:disable Rails/Output
require 'io/console'

module Operations::Setup
  class User < RailsOps::Operation
    schema3 {} # No params here

    YES_OPTIONS = %w[y Y].freeze

    def perform
      # Should only be ran if no other users are present
      # if User.any?
      #   puts "There are already users present, this is only used to create the first user!"
      #   return
      # end

      print 'This script creates the first admin user, that allows you to log in. Continue? [y/N] '
      response = $stdin.gets.chomp

      return unless YES_OPTIONS.include?(response)

      details_confirmed = false

      until details_confirmed
        username, email, password = get_details

        puts '---------------------------'
        puts "Username: #{username}"
        puts "Email: #{email}"
        print 'Are these details correct? Otherwise you can start again by entering `N`. [y/N] '

        response = $stdin.gets.chomp

        details_confirmed = true if YES_OPTIONS.include?(response)
      end

      # Create the user
      user = ::User.create!(
        email:        email,
        username:     username,
        password:     password,
        confirmed_at: Time.zone.now
      )

      # Create the user admin permission for the user
      ::UserPermission.create!(
        user:       user,
        permission: 'user_admin',
        mode:       'manage'
      )
    end

    private

    def get_password
      password_valid = false

      until password_valid
        print 'Enter password: '
        password = $stdin.noecho(&:gets).chomp
        puts

        if password.length < ::User::MIN_PASSWORD_LENGTH
          puts "Your password is too short, needs to be at least #{::User::MIN_PASSWORD_LENGTH} characters long!"
        elsif password.length > ::User::MAX_PASSWORD_LENGTH
          puts "Your password is too long, needs to be less than #{::User::MAX_PASSWORD_LENGTH} characters long!"
        else
          password_valid = true
        end
      end

      print 'Enter password confirmation: '
      password_confirmation = $stdin.noecho(&:gets).chomp
      puts

      [password, password_confirmation]
    end

    def get_email
      loop do
        print 'Enter email address: '
        email = $stdin.gets.chomp

        return email if URI::MailTo::EMAIL_REGEXP.match?(email)

        puts 'Your entered email is invalid!, please try again'
      end
    end

    def get_details
      print 'Enter username: '
      username = $stdin.gets.chomp

      email = get_email

      password, password_confirmation = get_password

      while password != password_confirmation
        puts 'Password and confirmation do not match, please enter again!'
        password, password_confirmation = get_password
      end

      [username, email, password]
    end
  end
end
# rubocop:enable Rails/Output
# rubocop:enable Naming/AccessorMethodName
