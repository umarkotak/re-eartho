class ForgetPasswordMailer < ApplicationMailer
  def new_forget_password_mailer
    @user = params[:user]
    @reset_password_link = "http://47.254.247.135/users/reset_password?forgot_token=#{@user.forgot_token}"

    mail(to: @user.email, subject: 'MARIANLOL | Password reset email')
  end
end
