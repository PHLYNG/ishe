module ApplicationHelper
  def full_title(page_title = '')
    base_title = "Ishe"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def exists_not?
    if Project.exists? == true
      return false
    else
      return true
    end
  end
end
