class EmailController < ApplicationController
  def check_for_comments
    Net::POP3.start('mail.avocadia.net', nil, 'm1178162', 'Gr8Cthulhu') do |pop|
      pop.each_mail do |m|
        print m.pop
      end
    end
  end
end
