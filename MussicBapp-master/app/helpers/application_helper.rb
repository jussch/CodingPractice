module ApplicationHelper

  def make_authenticity_token
    str = <<-HTML
      <input
      type="hidden"
      name="authenticity_token"
      value="#{form_authenticity_token}">
    HTML
    str.html_safe
  end

  def flash_now_information
    str = ""
    if flash.now[:errors]
      flash.now[:errors].each do |error|
        str += <<-HTML
          !! #{error} !!<br />
        HTML
      end
    end
    str.html_safe
  end

end
