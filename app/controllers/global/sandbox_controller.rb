module Global
  class SandboxController < ApiController
    def send_email
      ApplicationMailer.with({}).sandbox_email.deliver_now

      render_response
    end
  end
end
