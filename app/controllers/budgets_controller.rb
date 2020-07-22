class BudgetsController < ApplicationController

  def new
    build_budget
  end

  def create
    build_budget
    save_budget(form: 'new')
  end

  def edit
    load_budget
    build_budget
  end

  def update
    load_budget
    build_budget
    save_budget(form: 'new')
  end

  def show
    load_budget
  end

  def index
    load_budgets
  end

  def destroy
    load_budget
    if @budget.destroy
      redirect_to companies_path
    else
      redirect_to @budget, alert: 'Could not delete budget'
    end
  end

  private

  def build_budget
    @budget ||= budget_scope.build
    @budget.attributes = budget_attributes
  end

  def load_budget
    @budget ||= budget_scope.includes(:project).find(params[:id])
  end

  def save_budget(form:)
    if up.validate?
      @budget.valid? # run validations
      render form
    elsif @budget.save
      redirect_to @budget
    else
      render form, status: :bad_request
    end
  end

  def load_budgets
    @budgets = budget_scope.order(:name).to_a
  end

  def budget_scope
    Budget.all
  end

  def budget_attributes
    if (attrs = params[:budget])
      attrs.permit(:name, :amount, :project_id)
    else
      {}
    end
  end

end
