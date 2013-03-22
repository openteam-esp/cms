class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :manage, :all if user.manager_of?(nil)

    can :manage, :application do
      user.permissions.any?
    end

    can :manage, Node do |node|
      user.permissions.where(:context_type => 'Node').where(:context_id => node.path_ids).exists?
    end

    can :create, Site do
      user.manager?
    end

    can :manage, Part do |part|
      can? :manage, part.node
    end
  end
end
