require 'test_helper'

class CreateCategoriesTest < ActionDispatch::IntegrationTest

	def setup
		@blank_name = " "
	end

	test "get new category form and create category" do 
		# simulate https://localhost:3000/categories/new
		get new_category_path
		assert_template 'categories/new'
		
		# simulates HTTP POST to the create action of categories controller
		assert_difference 'Category.count', 1 do 
			post categories_path, params: {category: {name: "sports"}}
			follow_redirect!
		end
		
		# The https://localhost:3000/categories index page is displayed
		assert_template 'categories/index'

		# We assert that the word "sports" is present in the page
		assert_match "sports", response.body
	end

	test "invalid category submission results in failure" do 
		get new_category_path
		assert_template 'categories/new'
		
		assert_no_difference 'Category.count' do 
			post categories_path, params: {category: {name: @blank_name}}
		end

		assert_template 'categories/new'

		assert_select 'div.alert-danger'
		assert_select 'h4.alert-heading'
	end
end
