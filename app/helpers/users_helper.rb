module UsersHelper
  # Return the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for (user, size)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}.png"
    image_tag(gravatar_url, alt: user.name, class: "gravatar", size: "#{size}x#{size}")
  end
end
