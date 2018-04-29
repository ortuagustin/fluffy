module NotificationsHelper
  def notifications_class
    klass = 'navbar-item'
    klass << ' has-dropdown is-hoverable' if current_user.unread_notifications?
    klass
  end
end