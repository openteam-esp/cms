class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :manage, :application do
      user.have_permissions?
    end

    # app specific
    can :manage, Node do |node|
      user.manager?
    end

    can :manage, Node do |node|
      user.operator_of?(node)
    end

    can :manage, Node do |node|
      user.permissions.where(:context_type => 'Node').where(:context_id => node.ancestor_ids).exists?
    end

    can :create, Site do
      user.manager?
    end

    can :manage, Part do |part|
      can? :manage, part.node
    end
  end
end
