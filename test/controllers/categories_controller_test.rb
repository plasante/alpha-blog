require 'test_helper'

#
# 1- We test the routes 
#
class CategoriesControllerTest < ActionDispatch::IntegrationTest
	def setup
		@category = Category.create(name: "sports")
		@user = User.create(username: "Pierre", 
			                email: "pierre@example.com",
			                password: "password",
			                admin: true)
		@notAdmin = User.create(username: "Not Admin", 
			                    email: "notadmin@example.com",
			                    password: "password",
			                    admin: false)
	end

	test "should get categories index" do 
		get categories_path
		assert_response :success
	end

	test "should get categories new" do 
		sign_in_as(@user, "password")
		get new_category_path
		assert_response :success
	end

	test "should get categories show" do 
		get category_path(@category.id)
		assert_response :success
	end

	test "should redirect create action whan admin not logged in" do 
		sign_in_as(@notAdmin, "password")
		assert_no_difference 'Category.count' do 
			post categories_path, params: {category: {name: "sports"}}
		end
		assert_redirected_to categories_path
	end
end