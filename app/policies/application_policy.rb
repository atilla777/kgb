class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    if @user.has_any_role? :admin, :editor, :viewer
      true
    else
      false
    end
  end

  def show?
    if scope.where(:id => record.id).exists?
      true
    elsif
      @user.has_any_role? :admin, :editor, :viewer
    else
      false
    end
  end

  def create?
    if @user.has_any_role? :admin, :editor
      true
    else
      false
    end
  end

  def new?
    create?
  end

  def update?
    if @user.has_any_role? :admin, :editor
      true
    else
      false
    end
  end

  def edit?
    update?
  end

  def destroy?
    if @user.has_any_role? :admin, :editor
      true
    else
      false
    end
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

end
