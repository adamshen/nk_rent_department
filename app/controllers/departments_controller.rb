class DepartmentsController < ApplicationController
  def index
    # TODO: page nav
    @departments = Department.all.first(10)
  end
end
