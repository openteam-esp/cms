class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    ## common
    can :manage, Context do | context |
      user.manager_of? context
    end

    can :manage, Permission do | permission |
      permission.context && user.manager_of?(permission.context)
    end

    can [:new, :create], Permission do | permission |
      !permission.context && user.manager?
    end

    can [:search, :index], User do
      user.manager?
    end

    can :manage, :application do
      user.have_permissions?
    end

    can :manage, :permissions do
      user.manager?
    end

    can :manage, :audits do
      user.manager_of? Context.first
    end

    # app specific
    can :manage, Node do |node|
      [node] + node.ancestors.each do |n|
        return true if can?(:manage, n)
      end

      false
    end

    can :manage, Node do |node|
      user.manager_of?(node) || user.operator_of?(node)
    end

    can :manage, Node do |node|
      user.manager_of?(node.context) if node.context
    end

    can :create, Site do
      user.manager?
    end

    can :manage, Part do |part|
      can? :manage, part.node
    end
  end
end
