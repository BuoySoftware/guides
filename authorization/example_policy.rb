class ExamplePolicy < ApplicationPolicy
  def manage?
     master_grant? || grant?("manage:example")
  end

  def create?
     manage? || grant?("create:example")
  end

  def read?
     manage? || grant?("read:example")
  end

  def update?
     manage? || grant?("update:example")
  end

  def delete?
     manage? || grant?("delete:example")
  end
end
