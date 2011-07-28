class ListingMailer < ActionMailer::Base
  default from: "mailer@ourbulletins.com"

  def reply_listing(reply)
    @reply = reply
    @sender = reply.user
    @receiver = reply.listing.user
    subject = "RE: #{reply.listing.title}"
    mail(:to => "#{@receiver.name} <#{@receiver.email}>",
         :reply_to => "#{@sender.name} <#{@sender.email}>",
         :subject => subject)
  end
end
