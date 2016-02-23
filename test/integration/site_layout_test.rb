require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end

  test "layout links logged out" do
    get root_path
    assert_select "title", full_title()
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", signup_path
    assert_select "a[href=?]", login_path

    get help_path
    assert_select "title", full_title("Help")

    get about_path
    assert_select "title", full_title("About")

    get contact_path
    assert_select "title", full_title("Contact")
    
    get signup_path
    assert_select "title", full_title("Sign up")

    get login_path
    assert_select "title", full_title("Log In")

  end

  test "layout links logged in non admin" do
    log_in_as(@non_admin)

    get root_path
    assert_select "title", full_title()
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", user_path(@non_admin)
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", edit_user_path(@non_admin)

    get help_path
    assert_select "title", full_title("Help")

    get about_path
    assert_select "title", full_title("About")

    get contact_path
    assert_select "title", full_title("Contact")

    get users_path 
    assert_select "title", full_title("All user")
    assert_select "a[data-confirm=?]", 'Are you sure?', text: "delete", count: 0

    get user_path(@non_admin)
    assert_select "title", full_title(@non_admin.name)

    get edit_user_path(@non_admin)
    assert_select "title", full_title("Edit user")

  end

  test "layout links logged in as admin" do
    log_in_as(@admin)

    get root_path
    assert_select "title", full_title()
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", user_path(@admin)
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", edit_user_path(@admin)

    get help_path
    assert_select "title", full_title("Help")

    get about_path
    assert_select "title", full_title("About")

    get contact_path
    assert_select "title", full_title("Contact")

    get users_path 
    assert_select "title", full_title("All user")
    assert_select "a[data-confirm=?]", 'Are you sure?', text: "delete"

    get user_path(@admin)
    assert_select "title", full_title(@admin.name)

    get edit_user_path(@admin)
    assert_select "title", full_title("Edit user")

  end
end
