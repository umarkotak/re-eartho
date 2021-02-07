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

    def ask_forgot_password
      execute_reset_password_sequence
      render_response(data: { email: email })
    end

    def renew_password
      @user = User.find_by(forgot_token: renew_password_params[:forgot_token])
      unless @user.present?
        raise 'Unauthorized request'
      end
      execute_renew_password_sequence
      render_response(data: {})
    end

    private

    def email
      params[:email]
    end

    def register_params
      @register_params ||= params.permit(:username, :email, :password, :password_confirmation)
    end

    def renew_password_params
      @renew_password_params ||= params.permit(:password, :password_confirmation, :forgot_token)
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
      user.update!(session_key: session_key, forgot_token: nil)

      {
        session_key: session_key,
        username: user.username,
        email: user.email,
        role: user.role,
        avatar_url: user.generated_avatar_url
      }
    end

    def execute_reset_password_sequence
      payloads = {email: email}
      user = User.find_by(email: email)
      return unless user.present?
      user.forgot_token = "#{SecureRandom.uuid}-#{SecureRandom.uuid}"
      user.save!
      ForgetPasswordMailer.with(user: user).new_forget_password_mailer.deliver_now
    end

    def execute_renew_password_sequence
      if renew_password_params[:password] != renew_password_params[:password_confirmation]
        raise 'password and password confirmation missmatch'
      end

      pass_encrypted = Digest::SHA2.hexdigest(renew_password_params[:password])
      @user.password_encrypted = pass_encrypted
      @user.forgot_token = nil
      @user.save!
    end
  end
end
