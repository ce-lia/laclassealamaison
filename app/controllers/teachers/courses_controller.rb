class Teachers::CoursesController < ApplicationController
  layout "teacher"

  def index
    @courses = current_user.courses
  end

  def create
    @course = current_user.courses.create!(course_params)
    redirect_to teachers_courses_path
  end

  def edit
    @course = current_user.courses.find(params[:id])
  end

  def update
    @course = current_user.courses.find(params[:id])
    @course.update!(course_params)
    redirect_to teachers_courses_path
  end

  def new
    @course = current_user.courses.build
  end

  def show
    @course = current_user.courses.find(params[:id])

    model = if current_user.admin?
              ClassroomAnimation
            else
              current_user.classroom_animations
            end
    @current_classroom_animations = model.live.order(starts_at: :asc)

    @future_classroom_animations = model.where('starts_at > ?', DateTime.now - 1.hour).order(starts_at: :asc)
  end

  private

  def course_params
    params.require(:course).permit(:title, :description, :content, :classroom_id, :published)
  end
end
