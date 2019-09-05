module ApplicationHelper
  def render_flash(type)
    message = flash[type]
    unless message.blank?
      render(partial: 'flash', locals: {type: type, message: message})
    end
  end

  def mailbox_icon
    count_unread = current_team.team_messages.where(read: false).count
    render(partial: 'mailbox_icon', locals: {number: count_unread})
  end

  def menu_item(text, path, icon, **options)
    render(partial: 'menu_item',
           locals: {text: text, path: path, icon: icon, options: options})
  end

  def submenu(text, icon, &block)
    block = capture(&block)
    render(partial: 'submenu',
           locals: {text: text, icon: icon, block: block})
  end

  def submenu_item(text, path, **options)
    render(partial: 'submenu_item',
           locals: {text: text, path: path, options: options})
  end
end
