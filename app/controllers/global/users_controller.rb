module Global
  class UsersController < ApiController
    def register
      created_user = execute_register
      render_response(data: { id: created_user.id })
    end

    def login
      result = execute_login
      render_response(data: result)
    end

    private

    def register_params
      @register_params ||= params.permit(:username, :email, :password, :password_confirmation)
    end

    def execute_register
      if register_params[:password] != register_params[:password_confirmation]
        raise 'password and password confirmation missmatch'
      end

      pass_encrypted = Digest::SHA2.hexdigest(register_params[:password])
      User.create!(
        username: register_params[:username],
        email: register_params[:email],
        password_encrypted: pass_encrypted,
        role: 'basic_user',
        status: '1'
      )
    end

    def login_params
      @login_params ||= params.permit(:email, :password)
    end

    def execute_login
      pass_encrypted = Digest::SHA2.hexdigest(login_params[:password])

      user = User.find_by(email: login_params[:email], password_encrypted: pass_encrypted)
      if user == nil
        raise 'invalid email or password'
      end

      session_key = "Bearer #{SecureRandom.uuid}-#{SecureRandom.uuid}-#{SecureRandom.uuid}"
      user.update!(session_key: session_key)

      {
        session_key: session_key,
        username: user.username,
        email: user.email,
        role: user.role
      }
    end
  end
end
