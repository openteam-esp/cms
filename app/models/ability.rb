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

    # app specific
    can :manage, Node do |node|
      user.manager_of? node.context
    end

    can :manage, Node do |node|
      user.manager_of? node
    end

    # TODO
    can :manage, [Site, Locale, Page, Part] do |part|
      true
    end
  end
end
