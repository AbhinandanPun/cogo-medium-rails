class ShareListAndPostMailer < ApplicationMailer
    default from: 'Abhinsdan@gmail.com'
    def share_list_email(list, user, recipient_email)
      @list = list
      @post = Post.where(id: ListPost.where(list: list).pluck(:post_id))

      @current_user = user
      @recipient_email = recipient_email
      mail(
        to: @recipient_email,
        subject: 'Shared List by ' + @current_user.username
      )
    end
    def share_post(post, user, recipient_email)
      @post = post
      @current_user = user
      @recipient_email = recipient_email
      mail(
        to: @recipient_email,
        subject: 'Shared post by ' + @current_user.username
      )
    end
end
