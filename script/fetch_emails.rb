#!/usr/bin/ruby

require 'net/imap'
require 'net/http'
require 'rubygems'

mail_settings = YAML.load(File.read(File.join(RAILS_ROOT, 'config', 'mail.yml')))

begin
  imap = Net::IMAP.new(mail_settings['imap_server'], mail_settings['imap_port'], true)
  imap.login(mail_settings['imap_username'], mail_settings['imap_password'])

  # select inbox as our mailbox to process
  imap.select('Inbox')
  # get all emails that are in inbox that have not been deleted
  # imap.uid_search(["NOT", "DELETED"]).each do |uid|
  imap.uid_search(["NOT", "SEEN"]).each do |uid|
    # fetches the straight up source of the email
    source   = imap.uid_fetch(uid, 'RFC822').first.attr['RFC822']
    # Post emails to rails
    if MailInterface.receive(source)
      # Delete the email
      # imap.uid_store(uid, "+FLAGS", [:Deleted])
      # -or- Mark read
      imap.uid_store(uid, "+FLAGS", [:Seen])
    else
      # imap.uid_store(uid, "+FLAGS", [:Seen, :Flagged])
      imap.uid_store(uid, "+FLAGS", [:Seen, :Flagged])
    end
  end

  # expunge removes the deleted emails
  # imap.expunge
  imap.logout

  # NoResponseError and ByResponseError happen often when imap'ing
  rescue Net::IMAP::NoResponseError => e
    # Log if you'd like
  rescue Net::IMAP::ByeResponseError => e
    # Log if you'd like
  rescue => e
    puts e
end