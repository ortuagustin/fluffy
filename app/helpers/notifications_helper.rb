module NotificationsHelper
  def notifications_class
    klass = 'navbar-item'
    klass << ' has-dropdown is-hoverable' if current_user.unread_notifications?
    klass
  end

  def bell_class
    current_user.unread_notifications? ? 'navbar-link': 'navbar-item has-text-white'
  end

  def bell_padding
    current_user.unread_notifications? ? '': 'padding: 0;'
  end
end