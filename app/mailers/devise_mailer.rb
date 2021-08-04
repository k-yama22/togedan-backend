class DeviseMailer < Devise::Mailer
    def headers_for(action, opts)
        super.merge!(template_path: 'layouts')
    end
    def confirmation_instructions(record, token, opts={})
      if record.unconfirmed_email != nil
        opts[:subject] = "メールアドレス変更手続きのご連絡"
      else
        opts[:subject] = "仮登録完了のご連絡"
      end
      super
    end
  end