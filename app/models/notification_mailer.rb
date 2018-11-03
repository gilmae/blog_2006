class NotificationMailer < ActionMailer::Base

  def new_comment(comment)
    subject       "[blog.avocadia.net] #{comment.title}"
    body          :comment=>comment
    recipients    comment.blog.editors.inject([]){|sum,editor|sum << editor.email}.join(',')
    from          "#{comment.author.name} <blog_followups@avocadia.net>"
    sent_on       Time.now
    content_type  'text/html'
    headers       'reply_to'=>'blog_followups@avocadia.net'
  end

  def receive(mail)
    if /\[\[DONOTDELETE\s(tag:avocadia.net,\d{4}-\d{2}-\d{2}:\/(\d{4}\/\d{2}\/\d{2}\/[\w\d_]+)),(\d+)\n([\d\w:\s]+),([\w\d]+),([\w\d]+)\n\]\]/ =~ mail
      matches = mail.scan(/\[\[DONOTDELETE\s(tag:avocadia.net,\d{4}-\d{2}-\d{2}:(\/\d{4}\/\d{2}\/\d{2}\/[\w\d_]+)),(\d+)\n([\d\w:\s]+),([\w\d]+),([\w\d]+)\n\]\]/)

      token = Token.new({:created_at=>matches[0][3],:nonce=>matches[0][4], :token=>matches[0][5]})

      parent = Node.find_by_permalink(matches[0][1])
      author = Author.find(matches[0][2])
      if parent && author
        if token.verify_with_immortality("there's no there there")
          node = Node.new
          node.body = "something here, eh?"
          node.author = author
          node.parent = parent
          node.token = token
          node.ip = Ip.new({:ip=>'email'})
          node.save     
        end
      end
    end

  
  end

  def self.check_for_followups
    Net::POP3.start('mail.avocadia.net', nil, 'm1178162', 'Gr8Cthulhu') do |pop|
      pop.each_mail do |m|
        receive(m)
      end
    end
  end
end
