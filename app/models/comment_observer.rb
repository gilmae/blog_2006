class CommentObserver < ActiveRecord::Observer
  
  def after_create(comment)
    comment.check_akismet!
    
    send_comment_notification(comment)
  end
  
  
  
  def send_comment_notification(comment)
    NotificationMailer.deliver_new_comment(comment)
  end
end
