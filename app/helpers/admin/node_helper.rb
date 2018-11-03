# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

module Admin::NodeHelper

  def followup_permissioning node
    html = ""
    if node.comments_closed
      html << "Thread is closed to followups"
    else
      html << button_to("Close thread", :action=>:close_thread, :id=>@node.id)
    end
  end
end
