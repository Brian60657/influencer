class SessionsController < ApplicationController

  def new
  end

  def create
    # look-up User in db by the email address submitted to the login form
    # convert to lowercase to match email in db in case they had caps lock on
    user = User.find_by(email: params[:login][:email].downcase)

    # verify user exists in db and run has_secure_password's .authenticate()
    # method to see if the password submitted on the login form was correct
    if user && user.authenticate(params[:login][:password])

      # save the user.id in that user's session cookie
      session[:user_id] = user.id.to_s
      redirect_to new_post_path, notice: "Logged in!"
    else

      # if email or password is incorrect, re-render login page
      flash.now.alert = "Incorrect email or password...try again!"
      render :new
    end
  end

  def destroy
    # delete the saved user_id key/value from the cookie
    session.delete(:user_id)
    redirect_to login_path, notice: "Logged out!"
  end

end
