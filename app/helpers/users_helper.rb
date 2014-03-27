module UsersHelper
  def display_name
    "#{@user.username} (#{@user.name})"
  end
end
