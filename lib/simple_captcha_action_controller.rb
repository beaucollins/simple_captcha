# Copyright (c) 2008 [Sur http://expressica.com]

require 'application'

module SimpleCaptcha #:nodoc 
  module ControllerHelpers #:nodoc
    
    include ConfigTasks #:nodoc
    
    # This method is to validate the simple captcha in controller.
    # It means when the captcha is controller based i.e. :object has not been passed to the method show_simple_captcha.
    #
    # *Example*
    #
    # If you want to save an object say @user only if the captcha is validated then do like this in action...
    #
    #  if simple_captcha_valid?
    #   @user.save
    #  else
    #   flash[:notice] = "captcha did not match"
    #   redirect_to :action => "myaction"
    #  end
    def simple_captcha_valid?
      return true if RAILS_ENV == 'test'
      if params[:captcha]
        data = simple_captcha_value
        result = data == params[:captcha].delete(" ").upcase
        simple_captcha_passed! if result
        return result
      else
        return false
      end
    end
    
    def get_simple_captcha_image
      send_file simple_captcha_image_name, :type => 'image/jpeg', :disposition => 'inline', :filename => params[:id] + ".jpg"
    end
    
    def simple_captcha_image_style #:nodoc
      return "default" if params[:image_style].nil? || params[:image_style].empty?
      File.exist?(simple_captcha_image_path + params[:image_style]) ?
        params[:image_style] :
        "default"
    end
    
    def simple_captcha_image_name #:nodoc
      File.join(simple_captcha_image_path, 
        simple_captcha_image_style,
        simple_captcha_value.split("")[params[:id].to_i] + ".jpg"
        )
    end
    
    private :simple_captcha_image_style, :simple_captcha_image_name
  end
end


ApplicationController.module_eval do
  include SimpleCaptcha::ControllerHelpers
end
